require 'test_helper'

class StockTest < ActiveSupport::TestCase
  test "creating and deleting orders updates stock of products" do
    order = users(:benji).orders.build
    order.order_items.build(product: products(:fanta), count: 2)

    assert_difference "products(:fanta).stock", -2 do
      order.save(validate: false)
    end

    assert_difference "products(:fanta).stock", +2 do
      order.destroy
    end
  end
end
