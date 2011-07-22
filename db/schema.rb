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

ActiveRecord::Schema.define(:version => 20110601071934) do

  create_table "categories", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "deleted"
    t.integer  "signed_off_by_id"
    t.datetime "signed_off_at"
  end

  create_table "category_memberships", :force => true do |t|
    t.integer  "category_id"
    t.integer  "dependency_id"
    t.string   "target_type"
    t.integer  "target_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "dependency"
  end

  create_table "cost_categories", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.boolean  "deleted"
    t.integer  "signed_off_by_id"
    t.datetime "signed_off_at"
    t.string   "label"
    t.string   "default_capital_unit"
    t.string   "default_operating_unit"
    t.string   "default_fuel_unit"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "cost_boilerplate"
    t.string   "default_valid_for_quantity_of_fuel_unit"
  end

  create_table "cost_sources", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.boolean  "deleted"
    t.integer  "signed_off_by_id"
    t.datetime "signed_off_at"
    t.string   "label"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "costs", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.boolean  "deleted"
    t.integer  "signed_off_by_id"
    t.datetime "signed_off_at"
    t.string   "label"
    t.string   "capital"
    t.string   "operating"
    t.string   "fuel"
    t.string   "size"
    t.string   "life"
    t.string   "efficiency"
    t.string   "valid_in_year"
    t.string   "valid_for_quantity_of_fuel"
    t.integer  "cost_source_id"
    t.integer  "cost_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "output"
  end

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

  create_table "followings", :force => true do |t|
    t.integer  "user_id"
    t.string   "target_type"
    t.integer  "target_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "links", :force => true do |t|
    t.integer  "from_id"
    t.integer  "to_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "to_type"
    t.string   "from_type"
  end

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.string   "lowercase_title"
    t.integer  "latest_version_number"
    t.boolean  "is_picture"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "deleted"
    t.integer  "signed_off_by_id"
    t.datetime "signed_off_at"
  end

  create_table "pictures", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "medium_picture_width"
    t.integer  "medium_picture_height"
    t.boolean  "deleted"
    t.integer  "signed_off_by_id"
    t.datetime "signed_off_at"
  end

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "sequence", "scope"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "technologies", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "technology_cost_points", :force => true do |t|
    t.string   "name"
    t.text     "source"
    t.string   "capital_cost"
    t.string   "operating_cost"
    t.integer  "technology_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "technology_illustrations", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "capital_size"
    t.string   "operating_size"
    t.integer  "technology_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "titles", :force => true do |t|
    t.string   "title"
    t.integer  "length"
    t.string   "target_type"
    t.integer  "target_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",                     :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "sortable_name"
    t.text     "content"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.integer  "user_id"
    t.boolean  "deleted"
    t.integer  "signed_off_by_id"
    t.datetime "signed_off_at"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["sortable_name"], :name => "index_users_on_sortable_name"
  add_index "users", ["title"], :name => "index_users_on_title"
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

  create_table "versions", :force => true do |t|
    t.integer  "target_id"
    t.integer  "user_id"
    t.integer  "number"
    t.string   "title"
    t.text     "content"
    t.boolean  "is_picture"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "target_type"
    t.integer  "previous_version_id"
    t.integer  "signed_off_by_id"
    t.datetime "signed_off_at"
    t.string   "label"
    t.string   "default_capital_unit"
    t.string   "default_operating_unit"
    t.string   "default_fuel_unit"
    t.string   "capital"
    t.string   "operating"
    t.string   "fuel"
    t.string   "size"
    t.string   "life"
    t.string   "efficiency"
    t.string   "valid_in_year"
    t.string   "valid_for_quantity_of_fuel"
    t.integer  "cost_source_id"
    t.integer  "cost_category_id"
    t.string   "output"
  end

  add_index "versions", ["created_at"], :name => "index_versions_on_created_at"
  add_index "versions", ["number"], :name => "index_versions_on_number"
  add_index "versions", ["target_id"], :name => "index_versions_on_page_id"
  add_index "versions", ["user_id"], :name => "index_versions_on_user_id"

end
