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

ActiveRecord::Schema.define(:version => 20130726214656) do

  create_table "alerts", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "url"
    t.integer  "status"
  end

  create_table "alerts_phones", :id => false, :force => true do |t|
    t.integer "alert_id"
    t.integer "phone_id"
  end

  add_index "alerts_phones", ["alert_id", "phone_id"], :name => "index_alerts_phones_on_alert_id_and_phone_id"
  add_index "alerts_phones", ["phone_id"], :name => "index_alerts_phones_on_phone_id"

  create_table "phones", :force => true do |t|
    t.string   "phone_number"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

end
