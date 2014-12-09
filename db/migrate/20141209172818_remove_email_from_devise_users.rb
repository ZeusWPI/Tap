class RemoveEmailFromDeviseUsers < ActiveRecord::Migration
  def change
    remove_index :users, :confirmation_token
    remove_index :users, :email
    remove_index :users, :reset_password_token

    change_table(:users) do |t|
      t.remove :email

      t.remove :reset_password_token
      t.remove :reset_password_sent_at

      t.remove :confirmation_token
      t.remove :confirmed_at
      t.remove :confirmation_sent_at
      t.remove :unconfirmed_email
    end
  end
end
