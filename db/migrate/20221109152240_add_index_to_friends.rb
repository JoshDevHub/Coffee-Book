class AddIndexToFriends < ActiveRecord::Migration[7.0]
  def up
    add_index :friendships,
              'least(sender_id, receiver_id), greatest(sender_id, receiver_id)',
              name: "index_friends",
              unique: true
  end

  def down
    remove_index :friendships, name: "index_friends"
  end
end
