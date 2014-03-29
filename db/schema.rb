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

ActiveRecord::Schema.define(:version => 20140223132752) do

  create_table "categories", :force => true do |t|
    t.string   "name",                                         :null => false
    t.text     "description"
    t.string   "color",       :limit => 6,                     :null => false
    t.string   "icon",        :limit => 32
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.integer  "parent_id"
    t.boolean  "deleted",                   :default => false
    t.string   "map_icon"
  end

  create_table "cities", :force => true do |t|
    t.string   "name",                           :null => false
    t.string   "slug"
    t.decimal  "lat"
    t.decimal  "long"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.boolean  "active",      :default => true
    t.string   "website"
    t.text     "description"
    t.integer  "image_id"
    t.boolean  "deleted",     :default => false
    t.string   "facebook"
  end

  create_table "comments", :force => true do |t|
    t.integer  "issue_id",                                        :null => false
    t.integer  "user_id",                                         :null => false
    t.text     "text",          :limit => 255,                    :null => false
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
    t.boolean  "admin_comment",                :default => false
    t.integer  "status_first",                 :default => 0
    t.integer  "status_second",                :default => 0
  end

  create_table "follows", :force => true do |t|
    t.integer  "user_id"
    t.string   "type"
    t.integer  "follow_ref_id", :null => false
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "forgot_passwords", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.string   "token",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "images", :force => true do |t|
    t.integer  "issue_id"
    t.text     "image"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "issues", :force => true do |t|
    t.integer  "user_id",                           :null => false
    t.integer  "category_id",                       :null => false
    t.string   "title",                             :null => false
    t.text     "description",                       :null => false
    t.string   "slug"
    t.decimal  "lat"
    t.decimal  "long"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "status",             :default => 1, :null => false
    t.integer  "city_id",            :default => 1, :null => false
    t.integer  "vote_count",         :default => 0
    t.integer  "view_count",         :default => 0
    t.integer  "comment_count",      :default => 0
    t.integer  "share_count",        :default => 0
    t.integer  "session_view_count", :default => 0
  end

  add_index "issues", ["slug"], :name => "index_issues_on_slug", :unique => true
  add_index "issues", ["status"], :name => "index_issues_on_status"

  create_table "unique_views", :force => true do |t|
    t.integer  "session",    :null => false
    t.integer  "issue_id",   :null => false
    t.datetime "viewed_at"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "unique_views", ["session", "issue_id"], :name => "index_unique_views_on_session_and_issue_id"

  create_table "updates", :force => true do |t|
    t.integer  "user_id"
    t.integer  "issue_id"
    t.string   "subject"
    t.text     "text"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "updates", ["user_id", "issue_id"], :name => "index_updates_on_user_id_and_issue_id"

  create_table "users", :force => true do |t|
    t.string   "email",                            :null => false
    t.string   "password_hash"
    t.string   "uuid"
    t.string   "fb_id"
    t.string   "fb_token"
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "anonymous",     :default => false, :null => false
    t.boolean  "active",                           :null => false
    t.integer  "role",                             :null => false
    t.string   "locale",                           :null => false
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.integer  "city_id"
    t.integer  "image_id"
    t.text     "description"
    t.string   "website"
    t.boolean  "deleted",       :default => false
    t.string   "twitter_id"
    t.string   "twitter_token"
    t.string   "script"
  end

  add_index "users", ["email", "fb_id", "fb_token"], :name => "index_users_on_email_and_fb_id_and_fb_token"

  create_table "votes", :force => true do |t|
    t.integer "user_id",  :null => false
    t.integer "issue_id", :null => false
  end

  add_index "votes", ["user_id", "issue_id"], :name => "index_votes_on_user_id_and_issue_id", :unique => true

end
