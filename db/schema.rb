# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_02_01_025434) do

  create_table "games", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "finished_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "current_level_id"
    t.integer "player_x"
    t.integer "player_y"
  end

  create_table "levels", force: :cascade do |t|
    t.integer "game_id", null: false
    t.integer "depth", default: 0, null: false
    t.integer "width", null: false
    t.integer "height", null: false
    t.text "tiles", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "entrance_x", default: -1, null: false
    t.integer "entrance_y", default: -1, null: false
  end

  create_table "monsters", force: :cascade do |t|
    t.integer "level_id", null: false
    t.integer "monster_x", null: false
    t.integer "monster_y", null: false
    t.integer "health", null: false
    t.integer "monster_level", null: false
    t.string "monster_type", limit: 32, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.string "refresh_token"
    t.string "access_token"
    t.datetime "expires"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
