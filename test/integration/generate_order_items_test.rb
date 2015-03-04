require 'test_helper'

class GenerateOrderItemsTest < ActiveSupport::TestCase
  test "g_order_items works" do
    order = Order.new
    products = Product.all.where("stock > 0")
    size = products.size

    order.order_items.build(product: products(:fanta), count: 150)
    order.order_items.build(product: products(:mate), count: 50)
    order.g_order_items(products)

    assert_equal order.order_items.size, size
    assert_equal order.order_items.select { |oi| oi.product == products(:fanta) }.first.count, products(:fanta).stock
    assert_equal order.order_items.select { |oi| oi.product == products(:cola) }.size, 0
    assert_equal order.order_items.select { |oi| oi.product == products(:mate) }.first.count, 50
    assert_equal order.order_items.select { |oi| oi.product == products(:bueno) }.first.count, 0
  end
end
