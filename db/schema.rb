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

ActiveRecord::Schema.define(version: 20130830053651) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "buildings", force: true do |t|
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.spatial  "lonlat",       limit: {:srid=>4326, :type=>"point", :geographic=>true}
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "neighborhood"
    t.string   "county"
  end

  create_table "endorsements", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "email"
    t.string   "unit"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "candidate_id"
    t.integer  "building_id"
  end

  create_table "locations", force: true do |t|
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "unit"
    t.integer  "locationable_id"
    t.string   "locationable_type"
    t.spatial  "lonlat",            limit: {:srid=>4326, :type=>"point", :geographic=>true}
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
