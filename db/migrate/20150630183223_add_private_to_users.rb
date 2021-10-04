class AddPrivateToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :private, :boolean, default: false
  end
end
