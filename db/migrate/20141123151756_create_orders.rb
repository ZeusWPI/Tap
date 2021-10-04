class CreateOrders < ActiveRecord::Migration[4.2]
  def change
    create_table :orders do |t|
      t.references :user, index: true
      t.string :products
      t.integer :cost

      t.timestamps null: false
    end
    add_index :orders, [:user_id, :created_at]
  end
end
