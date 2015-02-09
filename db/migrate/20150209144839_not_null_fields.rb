class NotNullFields < ActiveRecord::Migration
  def change
    change_column :order_items, :product_id, :integer, null: false
    change_column :order_items, :order_id, :integer, null: false
  end
end
