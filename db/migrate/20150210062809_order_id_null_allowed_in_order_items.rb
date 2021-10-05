class OrderIdNullAllowedInOrderItems < ActiveRecord::Migration[4.2]
  def up
    change_column :order_items, :order_id, :integer, null: true
  end

  def down
    change_column :order_items, :order_id, :integer, null: false
  end
end
