class CreateUsers < ActiveRecord::Migration[4.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :last_name
      t.integer :balance
      t.string :nickname
      t.string :password_digest

      t.timestamps
    end
  end
end
