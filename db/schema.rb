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

ActiveRecord::Schema.define(version: 20150129004947) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.datetime "time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["user_id"], name: "index_events_on_user_id", using: :btree

  create_table "guests", force: true do |t|
    t.integer  "event_id"
    t.string   "name"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "guests", ["event_id"], name: "index_guests_on_event_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email"
    t.string   "username"
    t.string   "password"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "venues", force: true do |t|
    t.integer "event_id"
    t.string  "name"
    t.string  "address"
    t.string  "url"
  end

  add_index "venues", ["event_id"], name: "index_venues_on_event_id", using: :btree

  create_table "votes", force: true do |t|
    t.integer  "event_id"
    t.integer  "guest_id"
    t.integer  "venue_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["event_id"], name: "index_votes_on_event_id", using: :btree
  add_index "votes", ["guest_id"], name: "index_votes_on_guest_id", using: :btree
  add_index "votes", ["venue_id"], name: "index_votes_on_venue_id", using: :btree

end
