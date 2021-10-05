class RemoveProviderFromUsers < ActiveRecord::Migration[4.2]
  def change
    remove_column :users, :provider, :string
  end
end
