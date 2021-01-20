# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_01_20_122508) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "afks", force: :cascade do |t|
    t.string "message"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_afks_on_user_id"
  end

  create_table "archive_configs", force: :cascade do |t|
    t.bigint "server"
    t.bigint "channel"
  end

  create_table "birthday_configs", force: :cascade do |t|
    t.bigint "server"
    t.bigint "channel"
    t.string "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "birthdays", force: :cascade do |t|
    t.integer "month"
    t.integer "day"
    t.bigint "server"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_birthdays_on_user_id"
  end

  create_table "game_keys", force: :cascade do |t|
    t.string "name"
    t.string "key"
    t.bigint "server"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "last_used_reactions", force: :cascade do |t|
    t.bigint "user_reaction_id"
    t.bigint "channel"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_reaction_id"], name: "index_last_used_reactions_on_user_reaction_id"
  end

  create_table "launch_alert_configs", force: :cascade do |t|
    t.string "server_id"
    t.string "channel_id"
  end

  create_table "launch_alerts", force: :cascade do |t|
    t.bigint "launch_alert_config_id"
    t.bigint "user_id"
    t.index ["launch_alert_config_id"], name: "index_launch_alerts_on_launch_alert_config_id"
    t.index ["user_id"], name: "index_launch_alerts_on_user_id"
  end

  create_table "role_colors", force: :cascade do |t|
    t.string "color"
    t.string "name"
    t.bigint "server"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "twitch_configs", force: :cascade do |t|
    t.bigint "server"
    t.bigint "channel"
  end

  create_table "twitch_streams", force: :cascade do |t|
    t.datetime "expires_at"
    t.bigint "server"
    t.integer "twitch_login"
  end

  create_table "user_commands", force: :cascade do |t|
    t.string "name"
    t.text "input"
    t.text "output"
    t.string "creator"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "alias", default: false
  end

  create_table "user_reactions", force: :cascade do |t|
    t.string "regex"
    t.text "output"
    t.string "creator"
    t.float "chance", default: 1.0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "server"
    t.datetime "last_used_at"
    t.datetime "first_used_at"
    t.integer "times_used", default: 0
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "banned", default: false
  end

end
