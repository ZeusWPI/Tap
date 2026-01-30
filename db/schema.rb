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

ActiveRecord::Schema[8.1].define(version: 2026_01_30_185518) do
  create_table "barcodes", force: :cascade do |t|
    t.string "code", default: "", null: false
    t.datetime "created_at", precision: nil
    t.integer "product_id", null: false
    t.datetime "updated_at", precision: nil
    t.index ["code"], name: "index_barcodes_on_code"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "attempts", default: 0, null: false
    t.datetime "created_at", precision: nil
    t.datetime "failed_at", precision: nil
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "locked_at", precision: nil
    t.string "locked_by"
    t.integer "priority", default: 0, null: false
    t.string "queue"
    t.datetime "run_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "order_items", force: :cascade do |t|
    t.integer "count", default: 0
    t.integer "order_id", null: false
    t.integer "product_id", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "price_cents"
    t.integer "transaction_id"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "user_id", null: false
    t.index ["created_at"], name: "index_orders_on_created_at"
    t.index ["user_id", "created_at"], name: "index_orders_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "avatar_content_type"
    t.string "avatar_file_name"
    t.bigint "avatar_file_size"
    t.datetime "avatar_updated_at", precision: nil
    t.integer "calories"
    t.integer "category", default: 0
    t.datetime "created_at", precision: nil
    t.boolean "deleted", default: false
    t.string "name", null: false
    t.integer "price_cents", default: 0, null: false
    t.integer "stock", default: 0, null: false
    t.datetime "updated_at", precision: nil
  end

  create_table "users", force: :cascade do |t|
    t.boolean "admin", default: false
    t.datetime "created_at", precision: nil
    t.integer "dagschotel_id"
    t.integer "frecency", default: 0, null: false
    t.boolean "koelkast", default: false
    t.string "name"
    t.integer "orders_count", default: 0
    t.boolean "private", default: false
    t.boolean "quickpay_hidden", default: false
    t.datetime "remember_created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "userkey"
    t.text "zauth_id", null: false
    t.index ["koelkast"], name: "index_users_on_koelkast"
    t.index ["orders_count"], name: "index_users_on_orders_count"
    t.index ["zauth_id"], name: "index_users_on_zauth_id", unique: true
  end

  add_foreign_key "barcodes", "products"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "products"
  add_foreign_key "orders", "users"
  add_foreign_key "users", "products", column: "dagschotel_id"
end
