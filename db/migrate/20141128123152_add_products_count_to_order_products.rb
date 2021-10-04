class AddProductsCountToOrderProducts < ActiveRecord::Migration[4.2]
  def change
    add_column :order_products, :count, :integer, default: 1
  end
end
