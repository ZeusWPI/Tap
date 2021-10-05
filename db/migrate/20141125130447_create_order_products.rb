class CreateOrderProducts < ActiveRecord::Migration[4.2]
  def change
    create_table :order_products do |t|
      t.belongs_to :order
      t.belongs_to :product
    end
  end
end
