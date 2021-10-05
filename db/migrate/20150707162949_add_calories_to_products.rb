class AddCaloriesToProducts < ActiveRecord::Migration[4.2]
  def change
    add_column :products, :calories, :int
  end
end
