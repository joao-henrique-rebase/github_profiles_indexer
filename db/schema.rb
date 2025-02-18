# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_02_17_190006) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "profiles", force: :cascade do |t|
    t.string "name"
    t.string "nickname"
    t.string "followers_count"
    t.string "following_count"
    t.string "stars_count"
    t.integer "contributions_count_last_year"
    t.text "avatar_url"
    t.text "github_url"
    t.text "short_github_url"
    t.string "organization"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end
