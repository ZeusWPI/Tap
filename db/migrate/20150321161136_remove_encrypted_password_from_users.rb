class RemoveEncryptedPasswordFromUsers < ActiveRecord::Migration[4.2]
  def change
    remove_column :users, :encrypted_password, :string
  end
end
