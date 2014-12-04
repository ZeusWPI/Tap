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

ActiveRecord::Schema.define(version: 20141204191328) do

  create_table "order_products", force: true do |t|
    t.integer "order_id"
    t.integer "product_id"
    t.integer "count",      default: 1
  end

  create_table "orders", force: true do |t|
    t.integer  "user_id"
    t.integer  "cost"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "orders", ["user_id", "created_at"], name: "index_orders_on_user_id_and_created_at"
  add_index "orders", ["user_id"], name: "index_orders_on_user_id"

  create_table "products", force: true do |t|
    t.string   "name"
    t.integer  "purchase_price"
    t.integer  "sale_price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "last_name"
    t.integer  "balance",         default: 0
    t.string   "nickname"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
