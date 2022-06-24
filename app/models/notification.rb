class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :friend_request

  scope :unread, -> { where(read: false) }
  scope :read, -> { where(read: true) }

  def mark_as_read
    update(read_status: true)
  end
end
