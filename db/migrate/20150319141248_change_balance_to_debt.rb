class ChangeBalanceToDebt < ActiveRecord::Migration[4.2]
  def change
    rename_column :users, :balance_cents, :debt_cents
  end
end
