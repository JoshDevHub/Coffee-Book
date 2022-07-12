class ChangeFriendRequestToFriendship < ActiveRecord::Migration[7.0]
  def change
    rename_table :friend_requests, :friendships
  end
end
