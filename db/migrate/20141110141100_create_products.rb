class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.integer :sale_price
      t.integer :purchase_price
      t.string	:image_path
      t.string :type

      t.timestamps
    end
  end
end
