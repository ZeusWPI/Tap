class ChangePriceToPriceCentsOrders < ActiveRecord::Migration[4.2]
  def change
    rename_column :orders, :price, :price_cents
  end
end
