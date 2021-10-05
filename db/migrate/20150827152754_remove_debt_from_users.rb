class RemoveDebtFromUsers < ActiveRecord::Migration[4.2]
  def change
    remove_column :users, :debt_cents, :int
  end
end
