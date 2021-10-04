class RemovePurchasePriceFromProducts < ActiveRecord::Migration[4.2]
  def change
    remove_column :products, :purchase_price, :integer
    rename_column :products, :sale_price, :price
  end
end
