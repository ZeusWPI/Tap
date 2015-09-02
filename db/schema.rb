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

ActiveRecord::Schema.define(version: 20150827155036) do

  create_table "order_items", force: :cascade do |t|
    t.integer "order_id"
    t.integer "product_id",             null: false
    t.integer "count",      default: 0
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "price_cents"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "cancelled",   default: false
  end

  add_index "orders", ["cancelled"], name: "index_orders_on_cancelled"
  add_index "orders", ["created_at"], name: "index_orders_on_created_at"
  add_index "orders", ["user_id", "created_at"], name: "index_orders_on_user_id_and_created_at"
  add_index "orders", ["user_id"], name: "index_orders_on_user_id"

  create_table "products", force: :cascade do |t|
    t.string   "name",                limit: 255,                 null: false
    t.integer  "price_cents",                     default: 0,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name",    limit: 255
    t.string   "avatar_content_type", limit: 255
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "category",                        default: 0
    t.integer  "stock",                           default: 0,     null: false
    t.integer  "calories"
    t.boolean  "deleted",                         default: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                   default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",  limit: 255
    t.string   "last_sign_in_ip",     limit: 255
    t.boolean  "admin"
    t.integer  "dagschotel_id"
    t.string   "avatar_file_name",    limit: 255
    t.string   "avatar_content_type", limit: 255
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "orders_count",                    default: 0
    t.boolean  "koelkast",                        default: false
    t.string   "provider"
    t.string   "uid"
    t.string   "encrypted_password",              default: "",    null: false
    t.boolean  "private",                         default: false
  end

  add_index "users", ["koelkast"], name: "index_users_on_koelkast"
  add_index "users", ["orders_count"], name: "index_users_on_orders_count"

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"

end
