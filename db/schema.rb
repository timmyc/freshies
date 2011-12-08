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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111205042618) do

  create_table "areas", :force => true do |t|
    t.string   "name"
    t.string   "key"
    t.string   "secret"
    t.string   "website"
    t.string   "latitude"
    t.string   "longitude"
    t.string   "twitter"
    t.string   "klass"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shredders", :force => true do |t|
    t.text     "mobile"
    t.text     "confirmation_code"
    t.integer  "area_id"
    t.integer  "inches"
    t.boolean  "active",            :default => false
    t.boolean  "confirmed",         :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "snow_reports", :force => true do |t|
    t.datetime "report_time"
    t.integer  "snowfall_twelve"
    t.integer  "snowfall_twentyfour"
    t.integer  "snowfall_seventytwo"
    t.integer  "base_temp"
    t.integer  "mid_temp"
    t.integer  "summit_temp"
    t.integer  "base_depth"
    t.integer  "mid_depth"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "area_id"
    t.boolean  "first_report",        :default => false
  end

  add_index "snow_reports", ["area_id"], :name => "index_snow_reports_on_area_id"
  add_index "snow_reports", ["report_time"], :name => "index_snow_reports_on_report_time"

end
