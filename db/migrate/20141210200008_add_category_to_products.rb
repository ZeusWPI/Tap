class AddCategoryToProducts < ActiveRecord::Migration[4.2]
  def change
    add_column :products, :category, :integer, default: 0
  end
end
