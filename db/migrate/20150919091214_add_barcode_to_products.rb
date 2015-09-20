class AddBarcodeToProducts < ActiveRecord::Migration
  def change
    add_column :products, :barcode, :string, null: false, default: ""
  end
end
