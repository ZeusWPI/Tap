class AddDeletedToProducts < ActiveRecord::Migration
  def change
    add_column :products, :deleted, :boolean, default: false
  end
end
