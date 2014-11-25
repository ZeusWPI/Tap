class DropProductsOnUsers < ActiveRecord::Migration
  def change
    remove_column :orders, :products
  end
end
