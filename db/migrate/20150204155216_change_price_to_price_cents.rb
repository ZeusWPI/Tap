class ChangePriceToPriceCents < ActiveRecord::Migration[4.2]
  def change
    rename_column :products, :price, :price_cents
  end
end
