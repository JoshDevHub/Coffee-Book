# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  first_name             :string
#  last_name              :string
#
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
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def name
    "#{first_name} #{last_name}"
  end

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

  def pending_friends
    sent_friend_requests.pending.map(&:receiver) +
      received_friend_requests.pending.map(&:sender)
  end

  private

  def send_notification(recipient, request)
    recipient.notifications.create(friend_request: request)
  end
end
