class AddManyToOneRelationToOrders < ActiveRecord::Migration
  def up
    add_column :orders, :product_id, :integer

    orders = Order.all
    orders.each do |order|
      OrderItem.where(order_id: order.id).each do |oi|
        product = Product.where(id: oi.id).first
        oi.count.times do
          o = Order.new user_id: order.user_id,
            price_cents: product.price_cents,
            created_at: order.created_at,
            updated_at: order.updated_at,
            transaction_id: order.transaction_id,
            product: product
          o.save(validate: false)
        end
      end
    end
  end

  def down
    remove_column :orders, :product_id, :integer
  end
end
