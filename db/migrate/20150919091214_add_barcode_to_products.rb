class AddBarcodeToProducts < ActiveRecord::Migration
  def change
    create_table :barcodes do |t|
      t.references :product
      t.string :code, index: true, null: false, default: ""

      t.timestamps
    end
  end
end
