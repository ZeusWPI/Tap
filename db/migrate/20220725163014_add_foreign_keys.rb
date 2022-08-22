class AddForeignKeys < ActiveRecord::Migration[6.1]
  def change
    # Actually use the "relational" part of the database.
    add_foreign_key :barcodes, :products
    add_foreign_key :order_items, :orders
    add_foreign_key :order_items, :products
    add_foreign_key :orders, :users
    add_foreign_key :users, :products, column: :dagschotel_id

    # Most foreign keys must not be null.
    change_column_null :barcodes, :product_id, false
    change_column_null :order_items, :order_id, false
    change_column_null :orders, :user_id, false
  end
end
