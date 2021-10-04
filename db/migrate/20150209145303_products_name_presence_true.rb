class ProductsNamePresenceTrue < ActiveRecord::Migration[4.2]
  def up
    change_column :products, :name, :string, null: false
  end

  def down
    change_column :products, :name, :string, null: true
  end
end
