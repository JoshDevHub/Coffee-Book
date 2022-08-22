# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  last_name              :string
#  provider               :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  uid                    :string
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
  has_many :likes,
           dependent: :destroy,
           foreign_key: "liker_id",
           inverse_of: "liker"

  has_one :profile, dependent: :destroy

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true

  after_create :create_profile!, :welcome_email

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  devise :omniauthable, omniauth_providers: %i[github]

  def self.from_omniauth(auth)
    user = find_or_initialize_by(provider: auth.provider, uid: auth.uid)
    user.email = auth.info.email
    user.password = Devise.friendly_token[0, 20]
    first_name, last_name = auth.info.name.split
    user.first_name = first_name
    user.last_name = last_name

    user.save
    user
  end

  def self.index_for(current_user)
    User.where.not(id: current_user.id)
  end

  def self.search_by_name(name)
    first, last, = name.split.map(&:downcase)
    first_search = first
    last_search = last || first_search
    User.where("lower(first_name) = ?", first)
        .or(User.where("lower(last_name) = ?", last_search))
  end

  def name
    "#{first_name} #{last_name}"
  end

  def send_friend_request(receiver)
    return if sent_friend_requests.exists?(receiver:) ||
              received_friend_requests.exists?(sender: receiver)

    sent_friend_requests.create(receiver:)
  end

  def friends
    sent_friend_requests.confirmed.includes(:receiver).map(&:receiver) +
      received_friend_requests.confirmed.map(&:sender)
  end

  def pending_friends
    sent_friend_requests.pending.includes(:receiver).map(&:receiver) +
      received_friend_requests.pending.map(&:sender)
  end

  def read_notifications
    notifications.each(&:mark_as_read)
  end

  def unread_notifications?
    notifications.exists?(read_status: false)
  end

  private

  def welcome_email
    UserMailer.with(user: self).welcome_email.deliver
  end
end
