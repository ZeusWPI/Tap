class RemoveFieldsFromUsers < ActiveRecord::Migration[4.2]
  def change
    remove_column :users, :nickname, :string
  end
end
