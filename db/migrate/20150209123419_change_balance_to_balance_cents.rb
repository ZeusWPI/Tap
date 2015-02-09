class ChangeBalanceToBalanceCents < ActiveRecord::Migration
  def change
    rename_column :users, :balance, :balance_cents
  end
end
