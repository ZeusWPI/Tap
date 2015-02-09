class ChangeOrderProductToOrderItem < ActiveRecord::Migration
  def change
    rename_table :order_products, :order_items
  end
end
