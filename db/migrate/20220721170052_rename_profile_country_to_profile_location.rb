class RenameProfileCountryToProfileLocation < ActiveRecord::Migration[7.0]
  def change
    rename_column :profiles, :country, :location
  end
end
