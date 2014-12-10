class AddOrdersCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :orders_count, :integer, default: 0
  end
end
