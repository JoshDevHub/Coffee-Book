# == Schema Information
#
# Table name: friendships
#
#  id          :bigint           not null, primary key
#  accepted    :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  receiver_id :bigint           not null
#  sender_id   :bigint           not null
#
# Indexes
#
#  index_friendships_on_receiver_id  (receiver_id)
#  index_friendships_on_sender_id    (sender_id)
#
# Foreign Keys
#
#  fk_rails_...  (receiver_id => users.id)
#  fk_rails_...  (sender_id => users.id)
#
class Friendship < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  has_many :notifications, as: :notifiable, dependent: :destroy

  scope :pending, -> { where(accepted: false) }
  scope :confirmed, -> { where(accepted: true) }

  NOTIFICATION_ACTION = "sent you a friend request!".freeze
  NOTIFICATION_PATH = "friendship_path".freeze

  def confirm
    update(accepted: true)
  end

  def notify(sender, recipient)
    notifications.create(
      user: recipient,
      message: notif_message_from(sender),
      url: NOTIFICATION_PATH
    )
  end

  private

  def notif_message_from(sender)
    "#{sender.name} #{NOTIFICATION_ACTION}"
  end
end
