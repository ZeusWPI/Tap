class AddZauthIdToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :zauth_id, :text

    add_index :users, :zauth_id, unique: true
  end
end
