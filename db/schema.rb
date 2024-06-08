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

ActiveRecord::Schema.define(version: 2024_06_08_163258) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "barcodes", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.string "code", limit: 255, default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["code"], name: "idx_16395_index_barcodes_on_code"
    t.index ["product_id"], name: "idx_16395_fk_rails_f6f6672052"
  end

  create_table "order_items", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "product_id", null: false
    t.bigint "count", default: 0
    t.index ["order_id"], name: "idx_16419_fk_rails_e3cb28f071"
    t.index ["product_id"], name: "idx_16419_fk_rails_f1a29ddd47"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "price_cents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "transaction_id"
    t.index ["created_at"], name: "idx_16414_index_orders_on_created_at"
    t.index ["user_id", "created_at"], name: "idx_16414_index_orders_on_user_id_and_created_at"
    t.index ["user_id"], name: "idx_16414_index_orders_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.bigint "price_cents", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "avatar_file_name", limit: 255
    t.string "avatar_content_type", limit: 255
    t.bigint "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.bigint "category", default: 0
    t.bigint "stock", default: 0, null: false
    t.bigint "calories"
    t.boolean "deleted", default: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "remember_created_at"
    t.boolean "admin", default: false
    t.bigint "dagschotel_id"
    t.string "avatar_file_name", limit: 255
    t.string "avatar_content_type", limit: 255
    t.bigint "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.bigint "orders_count", default: 0
    t.boolean "koelkast", default: false
    t.string "name", limit: 255
    t.boolean "private", default: false
    t.bigint "frecency", default: 0, null: false
    t.boolean "quickpay_hidden", default: false
    t.string "userkey", limit: 255
    t.index ["dagschotel_id"], name: "idx_16441_fk_rails_b21d65e995"
    t.index ["koelkast"], name: "idx_16441_index_users_on_koelkast"
    t.index ["orders_count"], name: "idx_16441_index_users_on_orders_count"
  end

  add_foreign_key "barcodes", "products", on_update: :restrict, on_delete: :restrict
  add_foreign_key "order_items", "orders", on_update: :restrict, on_delete: :restrict
  add_foreign_key "order_items", "products", on_update: :restrict, on_delete: :restrict
  add_foreign_key "orders", "users", on_update: :restrict, on_delete: :restrict
  add_foreign_key "users", "products", column: "dagschotel_id", on_update: :restrict, on_delete: :restrict
end
