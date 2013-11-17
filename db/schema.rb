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

ActiveRecord::Schema.define(:version => 20131114170758) do

  create_table "addresses", :force => true do |t|
    t.string  "city"
    t.string  "district"
    t.string  "street"
    t.float   "geo_x"
    t.float   "geo_y"
    t.integer "addressable_id"
    t.string  "addressable_type"
  end

  add_index "addresses", ["addressable_id", "addressable_type"], :name => "index_addresses_on_addressable_id_and_addressable_type"

  create_table "distribution_barcodes", :force => true do |t|
    t.integer  "owner"
    t.integer  "value",           :limit => 8, :default => 0
    t.integer  "creator"
    t.integer  "package_item_id"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.string   "barcode_string"
  end

  add_index "distribution_barcodes", ["barcode_string"], :name => "index_distribution_barcodes_on_barcode_string"

  create_table "distribution_package_item_state_transitions", :force => true do |t|
    t.integer  "package_item_id"
    t.string   "event"
    t.string   "from"
    t.string   "to"
    t.datetime "created_at"
  end

  add_index "distribution_package_item_state_transitions", ["package_item_id"], :name => "package_item_state_tr"

  create_table "distribution_package_items", :force => true do |t|
    t.integer  "item_id"
    t.string   "title"
    t.integer  "user_id"
    t.integer  "organizer_id"
    t.string   "organizer"
    t.string   "state_on_creation"
    t.boolean  "is_collected",           :default => false
    t.boolean  "is_user_participate",    :default => true
    t.boolean  "is_next_time_pickup",    :default => false
    t.integer  "package_id"
    t.string   "state"
    t.integer  "location"
    t.string   "recieved_from"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "receiving_group_number"
    t.string   "receiver"
    t.string   "not_conform_rules"
  end

  add_index "distribution_package_items", ["item_id"], :name => "index_distribution_package_items_on_item_id"
  add_index "distribution_package_items", ["user_id"], :name => "index_distribution_package_items_on_user_id"

  create_table "distribution_package_list_state_transitions", :force => true do |t|
    t.integer  "package_list_id"
    t.string   "event"
    t.string   "from"
    t.string   "to"
    t.datetime "created_at"
  end

  add_index "distribution_package_list_state_transitions", ["package_list_id"], :name => "package_list_state_transition_index"

  create_table "distribution_package_lists", :force => true do |t|
    t.string  "state"
    t.integer "package_limit"
    t.integer "closed_by"
    t.integer "point_id"
  end

  add_index "distribution_package_lists", ["point_id"], :name => "index_distribution_package_lists_on_point_id"

  create_table "distribution_package_state_transitions", :force => true do |t|
    t.integer  "package_id"
    t.string   "event"
    t.string   "from"
    t.string   "to"
    t.datetime "created_at"
  end

  add_index "distribution_package_state_transitions", ["package_id"], :name => "index_distribution_package_state_transitions_on_package_id"

  create_table "distribution_packages", :force => true do |t|
    t.integer  "order"
    t.string   "code"
    t.string   "state"
    t.string   "distribution_method", :default => "at_point"
    t.integer  "collector_id"
    t.date     "collection_date"
    t.string   "document_number"
    t.integer  "user_id"
    t.integer  "package_list_id"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  add_index "distribution_packages", ["package_list_id"], :name => "index_distribution_packages_on_package_list_id"
  add_index "distribution_packages", ["user_id"], :name => "index_distribution_packages_on_user_id"

  create_table "distribution_points", :force => true do |t|
    t.string  "title"
    t.integer "head_user"
    t.integer "default_day_package_limit", :default => 100
    t.text    "work_schedule"
    t.string  "phone"
  end

  create_table "notifications", :force => true do |t|
    t.string   "text"
    t.boolean  "is_read",    :default => false
    t.integer  "user_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.string   "icon"
  end

  create_table "points_users", :force => true do |t|
    t.integer "point_id"
    t.integer "employee_id"
  end

  create_table "roles", :force => true do |t|
    t.string "name"
  end

  create_table "roles_users", :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  create_table "schedules", :force => true do |t|
    t.date    "date"
    t.boolean "is_day_off",     :default => false
    t.time    "from"
    t.time    "till"
    t.integer "extension_id"
    t.string  "extension_type"
  end

  add_index "schedules", ["extension_id", "extension_type"], :name => "index_schedules_on_extension_id_and_extension_type"

end
