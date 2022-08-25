class MakeNotificationPolymorphic < ActiveRecord::Migration[7.0]
  def change
    change_table :notifications, bulk: true do |t|
      t.remove_references(:friendship)
      t.references :notifiable, polymorphic: true, null: false
      t.string :message
      t.string :url
    end
  end
end
