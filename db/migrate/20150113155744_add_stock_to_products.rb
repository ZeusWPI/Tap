class AddStockToProducts < ActiveRecord::Migration[4.2]
  def change
    add_column :products, :stock, :integer, default: 0
  end
end
