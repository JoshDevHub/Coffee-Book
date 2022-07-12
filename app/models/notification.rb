# == Schema Information
#
# Table name: notifications
#
#  id            :bigint           not null, primary key
#  read_status   :boolean          default(FALSE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  friendship_id :bigint           not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_notifications_on_friendship_id  (friendship_id)
#  index_notifications_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (friendship_id => friendships.id)
#  fk_rails_...  (user_id => users.id)
#
class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :friendship

  scope :unread, -> { where(read: false) }
  scope :read, -> { where(read: true) }

  def mark_as_read
    update(read_status: true)
  end
end
