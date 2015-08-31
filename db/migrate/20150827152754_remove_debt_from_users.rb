class RemoveDebtFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :debt, :int
  end
end
