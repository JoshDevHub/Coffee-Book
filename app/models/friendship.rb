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
  include Notify

  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  has_many :notifications, as: :notifiable, dependent: :destroy

  scope :pending, -> { where(accepted: false) }
  scope :confirmed, -> { where(accepted: true) }

  delegate :url_helpers, to: "Rails.application.routes"

  def confirm
    update(accepted: true)
  end

  private

  def notification_action
    if accepted?
      "accepted your friend request!"
    else
      "sent you a friend request!"
    end
  end

  def notification_path
    accepted? ? "" : url_helpers.user_friends_path(receiver.username)
  end
end
