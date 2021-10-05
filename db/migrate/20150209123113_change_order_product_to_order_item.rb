class ChangeOrderProductToOrderItem < ActiveRecord::Migration[4.2]
  def change
    rename_table :order_products, :order_items
  end
end
