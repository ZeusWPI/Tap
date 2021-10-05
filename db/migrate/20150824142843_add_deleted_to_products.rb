class AddDeletedToProducts < ActiveRecord::Migration[4.2]
  def change
    add_column :products, :deleted, :boolean, default: false
  end
end
