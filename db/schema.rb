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

ActiveRecord::Schema.define(:version => 20110605060630) do

  create_table "assistances", :force => true do |t|
    t.integer  "master_id"
    t.string   "assistant_name",    :limit => 32
    t.integer  "assistant_id",                    :default => 0
    t.boolean  "perm_blog_comment",               :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assistances", ["assistant_id"], :name => "index_assistances_on_assistant_id"
  add_index "assistances", ["assistant_name"], :name => "index_assistances_on_assistant_name"
  add_index "assistances", ["master_id", "assistant_id"], :name => "index_assistances_on_master_id_and_assistant_id"
  add_index "assistances", ["master_id", "assistant_name"], :name => "index_assistances_on_master_id_and_assistant_name", :unique => true
  add_index "assistances", ["master_id"], :name => "index_assistances_on_master_id"

  create_table "banners", :force => true do |t|
    t.integer  "user_id"
    t.string   "image"
    t.string   "url"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "banners", ["user_id"], :name => "index_banners_on_user_id"

  create_table "consumer_tokens", :force => true do |t|
    t.integer  "user_id"
    t.string   "type",       :limit => 30
    t.string   "token",      :limit => 32
    t.string   "secret",     :limit => 32
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "consumer_tokens", ["token"], :name => "token", :unique => true
  add_index "consumer_tokens", ["user_id"], :name => "index_consumer_tokens_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "nickname"
    t.string   "identity_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["identity_url"], :name => "index_users_on_identity_url", :unique => true
  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
