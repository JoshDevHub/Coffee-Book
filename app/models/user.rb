class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :sent_friend_requests, class_name: "FriendRequest",
                                  foreign_key: :sender_id,
                                  inverse_of: :sender,
                                  dependent: :destroy
  has_many :received_friend_requests, class_name: "FriendRequest",
                                      foreign_key: :receiver_id,
                                      inverse_of: :receiver,
                                      dependent: :destroy
  has_many :notifications, dependent: :destroy

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def send_friend_request(receiver)
    return if sent_friend_requests.exists?(receiver: receiver) ||
              received_friend_requests.exists?(sender: receiver)

    request = sent_friend_requests.create(receiver: receiver)
    send_notification(receiver, request)
  end

  def friends
    sent_friend_requests.confirmed.map(&:receiver) +
      received_friend_requests.confirmed.map(&:sender)
  end

  private

  def send_notification(recipient, request)
    recipient.notifications.create(friend_request: request)
  end
end
