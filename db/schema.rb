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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131203050821) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "super_duper",            :default => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "alerts", :force => true do |t|
    t.integer  "shredder_id"
    t.integer  "snow_report_id"
    t.integer  "area_id"
    t.boolean  "sent",            :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "subscription_id"
    t.date     "date_sent"
    t.integer  "number_id"
    t.string   "uuid"
    t.integer  "forecast_id"
    t.boolean  "clicked",         :default => false
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
    t.boolean  "active",              :default => true
    t.string   "sub_account_id"
    t.string   "footer_text"
    t.integer  "default_snow_amount"
    t.string   "sms_link"
    t.string   "sms_template"
  end

  add_index "areas", ["active"], :name => "index_areas_on_active"

  create_table "chairs", :force => true do |t|
    t.integer  "area_id"
    t.string   "short_code"
    t.string   "name"
    t.string   "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "chairs", ["area_id"], :name => "index_chairs_on_area_id"

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
    t.string   "queue"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "forecasts", :force => true do |t|
    t.integer  "area_id"
    t.string   "snowfall"
    t.integer  "snowfall_min"
    t.integer  "snowfall_max"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "numbers", :force => true do |t|
    t.string   "inbound"
    t.integer  "area_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "numbers", ["area_id"], :name => "index_numbers_on_area_id"
  add_index "numbers", ["inbound"], :name => "index_numbers_on_inbound"

  create_table "passes", :force => true do |t|
    t.integer  "shredder_id"
    t.string   "pass_number"
    t.integer  "total_vertical_feet"
    t.integer  "total_days"
    t.integer  "total_runs"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "promos", :force => true do |t|
    t.integer  "area_id"
    t.string   "message"
    t.integer  "impressions", :default => 0
    t.integer  "total_sent",  :default => 0
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.string   "gcm_id"
    t.string   "push_token"
  end

  add_index "shredders", ["confirmation_token"], :name => "index_shredders_on_confirmation_token", :unique => true
  add_index "shredders", ["reset_password_token"], :name => "index_shredders_on_reset_password_token", :unique => true

  create_table "sms_actions", :force => true do |t|
    t.integer "area_id"
    t.integer "chair_id"
    t.string  "command"
    t.string  "matcher"
    t.string  "response"
  end

  add_index "sms_actions", ["area_id"], :name => "index_sms_actions_on_area_id"
  add_index "sms_actions", ["command"], :name => "index_sms_actions_on_command"

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
