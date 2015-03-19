class ChangeBalanceToDebt < ActiveRecord::Migration
  def change
    rename_column :users, :balance_cents, :debt_cents
  end
end
