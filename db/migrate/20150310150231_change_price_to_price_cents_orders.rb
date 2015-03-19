class ChangePriceToPriceCentsOrders < ActiveRecord::Migration
  def change
    rename_column :orders, :price, :price_cents
  end
end
