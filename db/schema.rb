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

ActiveRecord::Schema.define(version: 20190408122720) do

  create_table "barcodes", force: :cascade do |t|
    t.integer  "product_id"
    t.string   "code",       default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "barcodes", ["code"], name: "index_barcodes_on_code"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "order_items", force: :cascade do |t|
    t.integer "order_id"
    t.integer "product_id",             null: false
    t.integer "count",      default: 0
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "price_cents"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "transaction_id"
  end

  add_index "orders", ["created_at"], name: "index_orders_on_created_at"
  add_index "orders", ["user_id", "created_at"], name: "index_orders_on_user_id_and_created_at"
  add_index "orders", ["user_id"], name: "index_orders_on_user_id"

  create_table "products", force: :cascade do |t|
    t.string   "name",                                null: false
    t.integer  "price_cents",         default: 0,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "category",            default: 0
    t.integer  "stock",               default: 0,     null: false
    t.integer  "calories"
    t.boolean  "deleted",             default: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "remember_created_at"
    t.boolean  "admin",               default: false
    t.integer  "dagschotel_id"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "orders_count",        default: 0
    t.boolean  "koelkast",            default: false
    t.string   "name"
    t.boolean  "private",             default: false
    t.integer  "frecency",            default: 0,     null: false
    t.boolean  "quickpay_hidden",     default: false
    t.string   "userkey"
  end

  add_index "users", ["koelkast"], name: "index_users_on_koelkast"
  add_index "users", ["orders_count"], name: "index_users_on_orders_count"

end
