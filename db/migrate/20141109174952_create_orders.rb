class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.text :products
      t.references :user, index: true

      t.timestamps
    end
    add_index :orders, [:user_id, :created_at]
  end
end
