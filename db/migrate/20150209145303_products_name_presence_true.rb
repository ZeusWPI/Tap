class ProductsNamePresenceTrue < ActiveRecord::Migration
  def up
    change_column :products, :name, :string, null: false
  end

  def down
    change_column :products, :name, :string, null: true
  end
end
