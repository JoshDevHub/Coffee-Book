class RemoveCommentPolymorphism < ActiveRecord::Migration[7.0]
  def up
    change_table :comments, bulk: true do |t|
      t.remove_references :commentable, polymorphic: true, null: false
      t.references :post
    end
  end

  def down
    change_table :comments, bulk: true do |t|
      t.references :commentable, polymorphic: true, null: false
      t.remove_reference(:post)
    end
  end
end
