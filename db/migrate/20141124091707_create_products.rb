class CreateProducts < ActiveRecord::Migration[4.2]
  def change
    create_table :products do |t|
      t.string :name
      t.integer :purchase_price
      t.integer :sale_price
      t.string :img_path

      t.timestamps
    end
  end
end
