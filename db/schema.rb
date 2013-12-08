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

ActiveRecord::Schema.define(version: 20131117154758) do

  create_table "actions", force: true do |t|
    t.integer  "alert_id"
    t.string   "action_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"

  create_table "admins", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "god_mode",               default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true

  create_table "alerts", force: true do |t|
    t.integer  "soundcloud_user_id"
    t.string   "title"
    t.integer  "play_count_min",     default: -1
    t.integer  "play_count_max",     default: -1
    t.integer  "like_count_min",     default: -1
    t.integer  "like_count_max",     default: -1
    t.integer  "download_count_min", default: -1
    t.integer  "download_count_max", default: -1
    t.integer  "duration_min",       default: -1
    t.integer  "duration_max",       default: -1
    t.boolean  "downloadable",       default: false
    t.boolean  "unplayed",           default: false
    t.boolean  "played",             default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "actionable",         default: false
  end

  create_table "soundcloud_recommendations", force: true do |t|
    t.integer  "user_id"
    t.integer  "track_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "processed",  default: false
  end

  add_index "soundcloud_recommendations", ["user_id", "track_id"], name: "index_soundcloud_recommendations_on_user_id_and_track_id", unique: true
  add_index "soundcloud_recommendations", ["user_id"], name: "index_soundcloud_recommendations_on_user_id"

  create_table "soundcloud_tracks", force: true do |t|
    t.integer  "track_id"
    t.string   "title"
    t.integer  "user_id"
    t.datetime "stats_last_updated"
    t.datetime "last_played"
    t.integer  "own_play_count",     default: 0
    t.datetime "uploaded_at"
    t.integer  "duration",           default: -1
    t.integer  "play_count",         default: -1
    t.integer  "download_count",     default: -1
    t.integer  "favorite_count",     default: -1
    t.integer  "comment_count",      default: -1
    t.boolean  "downloadable",       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "soundcloud_tracks", ["track_id"], name: "index_soundcloud_tracks_on_track_id"
  add_index "soundcloud_tracks", ["user_id"], name: "index_soundcloud_tracks_on_user_id"

  create_table "soundcloud_users", force: true do |t|
    t.integer  "user_id"
    t.string   "username"
    t.string   "name"
    t.string   "email"
    t.datetime "tracks_updated_at"
    t.string   "access_token"
    t.string   "refresh_token"
    t.string   "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "triggers", force: true do |t|
    t.integer  "soundcloud_user_id"
    t.integer  "alert_id"
    t.integer  "track_id"
    t.boolean  "processed",          default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "triggers", ["alert_id", "track_id"], name: "index_triggers_on_alert_id_and_track_id", unique: true
  add_index "triggers", ["soundcloud_user_id"], name: "index_triggers_on_soundcloud_user_id"

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "username",               default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "soundcloud_user_id"
    t.boolean  "soundcloud_connected"
    t.datetime "tracks_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["username"], name: "index_users_on_username"

end