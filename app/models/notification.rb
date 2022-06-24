class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :friend_request

  scope :unread, -> { where(read: false) }
  scope :read, -> { where(read: true) }
end
