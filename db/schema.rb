# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_07_25_163014) do

  create_table "barcodes", force: :cascade do |t|
    t.integer "product_id"
    t.string "code", default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["code"], name: "index_barcodes_on_code"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "order_items", force: :cascade do |t|
    t.integer "order_id"
    t.integer "product_id", null: false
    t.integer "count", default: 0
  end

  create_table "orders", force: :cascade do |t|
    t.integer "user_id"
    t.integer "price_cents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "transaction_id"
    t.index ["created_at"], name: "index_orders_on_created_at"
    t.index ["user_id", "created_at"], name: "index_orders_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.integer "price_cents", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer "category", default: 0
    t.integer "stock", default: 0, null: false
    t.integer "calories"
    t.boolean "deleted", default: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "remember_created_at"
    t.boolean "admin", default: false
    t.integer "dagschotel_id"
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer "orders_count", default: 0
    t.boolean "koelkast", default: false
    t.string "name"
    t.boolean "private", default: false
    t.integer "frecency", default: 0, null: false
    t.boolean "quickpay_hidden", default: false
    t.string "userkey"
    t.index ["koelkast"], name: "index_users_on_koelkast"
    t.index ["orders_count"], name: "index_users_on_orders_count"
  end

  add_foreign_key "barcodes", "products"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "products"
  add_foreign_key "orders", "users"
  add_foreign_key "users", "products", column: "dagschotel_id"
end
