class AddCaloriesToProducts < ActiveRecord::Migration
  def change
    add_column :products, :calories, :int
  end
end
