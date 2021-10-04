class ChangeCostToPriceInOrders < ActiveRecord::Migration[4.2]
  def change
    rename_column :orders, :cost, :price
  end
end
