class AddSomeIndexesToTables < ActiveRecord::Migration[4.2]
  def change
    add_index :orders, :created_at
    add_index :orders, :cancelled
  end
end
