class ChangeLikeUserToLikeLiker < ActiveRecord::Migration[7.0]
  def change
    rename_column :likes, :user_id, :liker_id
  end
end
