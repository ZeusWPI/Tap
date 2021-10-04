class ChangeBalanceToBalanceCents < ActiveRecord::Migration[4.2]
  def change
    rename_column :users, :balance, :balance_cents
  end
end
