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

ActiveRecord::Schema.define(:version => 20120116001059) do

  create_table "alerts", :force => true do |t|
    t.integer  "shredder_id"
    t.integer  "snow_report_id"
    t.integer  "area_id"
    t.boolean  "sent",            :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "subscription_id"
    t.date     "date_sent"
  end

  add_index "alerts", ["date_sent"], :name => "index_alerts_on_date_sent"

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
    t.boolean  "active",     :default => true
  end

  add_index "areas", ["active"], :name => "index_areas_on_active"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "shredders", :force => true do |t|
    t.text     "mobile"
    t.text     "confirmation_code"
    t.integer  "area_id"
    t.integer  "inches"
    t.boolean  "active",                                :default => false
    t.boolean  "confirmed",                             :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                                 :default => "",    :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
  end

  add_index "shredders", ["confirmation_token"], :name => "index_shredders_on_confirmation_token", :unique => true
  add_index "shredders", ["reset_password_token"], :name => "index_shredders_on_reset_password_token", :unique => true

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

  create_table "subscriptions", :force => true do |t|
    t.integer  "shredder_id"
    t.integer  "area_id"
    t.integer  "inches"
    t.string   "type"
    t.text     "message"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "intro"
    t.string   "gender"
    t.integer  "hour"
  end

  add_index "subscriptions", ["hour"], :name => "index_subscriptions_on_hour"

end
