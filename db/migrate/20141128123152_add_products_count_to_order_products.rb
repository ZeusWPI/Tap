class AddProductsCountToOrderProducts < ActiveRecord::Migration
  def change
    add_column :order_products, :count, :integer, default: 1
  end
end
