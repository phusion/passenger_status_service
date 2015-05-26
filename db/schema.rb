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

ActiveRecord::Schema.define(version: 20150525083129) do

  PRAGMA FOREIGN_KEYS = ON;
  create_table "users", force: :cascade do |t|
    t.string   "email",                  null: false
    t.string   "encrypted_password",     null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.boolean  "admin",                  default: false, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "apps", force: :cascade do |t|
    t.integer  "user_id",    null: false, foreign_key: {references: "users", name: "fk_apps_user_id", on_update: :cascade, on_delete: :cascade}
    t.string   "name",       null: false
    t.string   "api_token",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
  add_index "apps", ["api_token"], name: "index_apps_on_api_token", unique: true

  create_table "statuses", force: :cascade do |t|
    t.integer  "app_id",     null: false, foreign_key: {references: "apps", name: "fk_statuses_app_id", on_update: :cascade, on_delete: :cascade}
    t.string   "hostname",   null: false
    t.text     "content",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
  add_index "statuses", ["app_id", "hostname", "updated_at"], name: "statuses_index_on_3columns"

end
