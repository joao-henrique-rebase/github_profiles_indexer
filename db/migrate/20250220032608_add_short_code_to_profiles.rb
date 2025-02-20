class AddShortCodeToProfiles < ActiveRecord::Migration[8.0]
  def change
    add_column :profiles, :short_code, :string
    add_index :profiles, :short_code, unique: true
  end
end
