class DropProductsOnUsers < ActiveRecord::Migration[4.2]
  def change
    remove_column :orders, :products
  end
end
