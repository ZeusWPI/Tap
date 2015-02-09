class ProductsNamePresenceTrue < ActiveRecord::Migration
  def change
    change_column :products, :name, :string, null: false
  end
end
