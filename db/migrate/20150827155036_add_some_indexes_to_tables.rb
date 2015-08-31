class AddSomeIndexesToTables < ActiveRecord::Migration
  def change
    add_index :orders, :created_at
    add_index :orders, :cancelled
  end
end
