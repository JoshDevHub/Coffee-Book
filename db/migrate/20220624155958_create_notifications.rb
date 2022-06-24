class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :friend_request, null: false, foreign_key: true
      t.boolean :read_status, default: false

      t.timestamps
    end
  end
end
