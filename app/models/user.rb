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

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def send_friend_request(receiver)
    return if FriendRequest.exists?(sender: [self, receiver], receiver: [self, receiver])

    FriendRequest.create(sender: self, receiver: receiver)
  end

  def friends
    sent_friend_requests.confirmed.map(&:receiver) +
      received_friend_requests.confirmed.map(&:sender)
  end
end
