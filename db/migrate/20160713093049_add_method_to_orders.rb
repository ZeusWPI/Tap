class AddMethodToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :method, :string, default: 'tab'
  end
end
