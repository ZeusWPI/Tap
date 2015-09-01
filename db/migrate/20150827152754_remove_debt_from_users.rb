class RemoveDebtFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :debt_cents, :int
  end
end
