class AddCancelledBooleanToOrders < ActiveRecord::Migration[4.2]
  def change
    add_column :orders, :cancelled, :boolean, default: false
  end
end
