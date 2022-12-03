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

ActiveRecord::Schema[7.0].define(version: 2022_12_01_073411) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "leaderboards", force: :cascade do |t|
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_leaderboards_on_token", unique: true
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "sent_at", null: false
    t.text "content"
    t.string "kind", null: false
    t.boolean "is_unsent", null: false
    t.boolean "is_taken_down", null: false
    t.json "bumped_message_metadata", null: false
    t.json "json_reactions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_users_on_name", unique: true
  end

  add_foreign_key "messages", "users"
end
