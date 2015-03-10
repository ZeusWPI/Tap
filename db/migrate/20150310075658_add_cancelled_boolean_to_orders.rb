class AddCancelledBooleanToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :cancelled, :boolean, default: false
  end
end
