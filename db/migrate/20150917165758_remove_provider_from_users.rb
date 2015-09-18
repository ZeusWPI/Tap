class RemoveProviderFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :provider, :string
  end
end
