class AddOrdersCountToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :orders_count, :integer, default: 0
  end
end
