class NotNullFields < ActiveRecord::Migration
  def up
    change_column :order_items, :product_id, :integer, null: false
  end

  def down
    change_column :order_items, :product_id, :integer, null: true
  end
end
