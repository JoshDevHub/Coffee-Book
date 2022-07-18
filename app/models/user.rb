# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  last_name              :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  has_many :posts,
           dependent: :destroy,
           foreign_key: "author_id",
           inverse_of: "author"
  has_many :sent_friend_requests, class_name: "Friendship",
                                  foreign_key: :sender_id,
                                  inverse_of: :sender,
                                  dependent: :destroy
  has_many :received_friend_requests, class_name: "Friendship",
                                      foreign_key: :receiver_id,
                                      inverse_of: :receiver,
                                      dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :comments,
           dependent: :destroy,
           foreign_key: "commenter_id",
           inverse_of: "commenter"
  has_many :likes, dependent: :destroy

  has_one :profile, dependent: :destroy

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true

  after_create :create_profile!

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
    sent_friend_requests.confirmed.includes(:receiver).map(&:receiver) +
      received_friend_requests.confirmed.map(&:sender)
  end

  def pending_friends
    sent_friend_requests.pending.includes(:receiver).map(&:receiver) +
      received_friend_requests.pending.map(&:sender)
  end

  private

  def send_notification(recipient, request)
    recipient.notifications.create(friendship: request)
  end
end
