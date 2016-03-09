class AddManyToOneRelationToOrders < ActiveRecord::Migration
  def up
    add_column :orders, :product_id, :integer

    orders = Order.all
    orders.each do |order|
      order.order_items.each do |oi|
        oi.count.times do
          Order.create user_id: order.user_id,
            price_cents: oi.product.price_cents,
            created_at: order.created_at,
            updated_at: order.updated_at,
            transaction_id: order.transaction_id,
            product: oi.product
        end
      end
    end
  end

  def down
    remove_column :orders, :product_id, :integer
  end
end
