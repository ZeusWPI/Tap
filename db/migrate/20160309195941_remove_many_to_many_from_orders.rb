class RemoveManyToManyFromOrders < ActiveRecord::Migration
  def change
    drop_table :order_items

    remove_column :orders, :price_cents, :integer

    Order.where(product_id: nil).delete_all
  end
end
