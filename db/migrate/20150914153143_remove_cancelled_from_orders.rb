class RemoveCancelledFromOrders < ActiveRecord::Migration
  def change
    remove_column :orders, :cancelled, :boolean
    rename_column :users, :uid, :name
  end
end
