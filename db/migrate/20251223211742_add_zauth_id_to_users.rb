class AddZauthIdToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :zauth_id, :varchar
  end
end
