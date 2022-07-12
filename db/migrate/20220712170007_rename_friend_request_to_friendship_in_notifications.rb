class RenameFriendRequestToFriendshipInNotifications < ActiveRecord::Migration[7.0]
  def change
    rename_column :notifications, :friend_request_id, :friendship_id
  end
end
