# == Schema Information
#
# Table name: notifications
#
#  id                :bigint           not null, primary key
#  user_id           :bigint           not null
#  friend_request_id :bigint           not null
#  read_status       :boolean          default(FALSE)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :friend_request

  scope :unread, -> { where(read: false) }
  scope :read, -> { where(read: true) }

  def mark_as_read
    update(read_status: true)
  end
end
