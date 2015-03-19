class ChangeCostToPriceInOrders < ActiveRecord::Migration
  def change
    rename_column :orders, :cost, :price
  end
end
