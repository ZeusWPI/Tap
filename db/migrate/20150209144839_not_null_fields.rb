class NotNullFields < ActiveRecord::Migration[4.2]
  def up
    change_column :order_items, :product_id, :integer, null: false
  end

  def down
    change_column :order_items, :product_id, :integer, null: true
  end
end
