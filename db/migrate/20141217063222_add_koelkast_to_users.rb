class AddKoelkastToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :koelkast, :boolean, default: false
  end
end
