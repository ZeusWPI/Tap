class AddFrecencyToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :frecency, :integer, default: 0, null: false
  end
end
