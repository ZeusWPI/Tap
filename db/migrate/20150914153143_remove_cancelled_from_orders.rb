class RemoveCancelledFromOrders < ActiveRecord::Migration[4.2]
  def change
    remove_column :orders, :cancelled, :boolean
    rename_column :users, :uid, :name
  end
end
