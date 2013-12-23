# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20131223112654) do

  create_table "api_keys", force: true do |t|
    t.string "access_token"
  end

  add_index "api_keys", ["access_token"], name: "index_api_keys_on_access_token", unique: true

  create_table "events", force: true do |t|
    t.string   "type"
    t.datetime "occurred_at"
    t.text     "payload"
    t.integer  "revision_id"
  end

  create_table "revisions", force: true do |t|
    t.string  "resource_type"
    t.string  "resource_uuid"
    t.integer "resource_version"
  end

  add_index "revisions", ["resource_type", "resource_uuid", "resource_version"], name: "index_revisions_resource", unique: true

end
