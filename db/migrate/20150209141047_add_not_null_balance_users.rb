class AddNotNullBalanceUsers < ActiveRecord::Migration[4.2]
  def change
    change_column :users, :balance_cents, :integer, default: 0, null: false
  end
end
