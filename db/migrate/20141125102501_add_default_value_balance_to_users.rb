class AddDefaultValueBalanceToUsers < ActiveRecord::Migration[4.2]
  def change
    change_column :users, :balance, :integer, default: 0
  end
end
