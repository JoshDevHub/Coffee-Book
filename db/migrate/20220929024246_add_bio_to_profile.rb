class AddBioToProfile < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :bio, :string
  end
end
