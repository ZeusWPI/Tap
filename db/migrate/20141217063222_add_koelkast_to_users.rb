class AddKoelkastToUsers < ActiveRecord::Migration
  def change
    add_column :users, :koelkast, :boolean, default: false
  end
end
