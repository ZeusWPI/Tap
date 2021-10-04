class AddTransactionToOrders < ActiveRecord::Migration[4.2]
  def change
    add_column :orders, :transaction_id, :int
  end
end
