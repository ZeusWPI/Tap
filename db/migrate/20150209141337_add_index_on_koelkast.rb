class AddIndexOnKoelkast < ActiveRecord::Migration[4.2]
  def change
    add_index :users, :koelkast
    add_index :users, :orders_count
    change_column :products, :price_cents, :integer, default: 0, null: false
    change_column :products, :stock, :integer, default: 0, null: false
  end
end
  