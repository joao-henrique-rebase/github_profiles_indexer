class CreateProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :profiles do |t|
      t.string :name
      t.string :nickname
      t.string :followers_count
      t.string :following_count
      t.string :stars_count
      t.integer :contributions_count_last_year
      t.text :avatar_url
      t.text :github_url
      t.text :short_github_url
      t.string :organization
      t.string :location

      t.timestamps
    end
  end
end
