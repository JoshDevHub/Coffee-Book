class ChangeCommentUserToCommentCommenter < ActiveRecord::Migration[7.0]
  def change
    rename_column :comments, :user_id, :commenter_id
  end
end
