require 'test_helper'

class StockValidatorTest < ActiveSupport::TestCase
  test "form gives error when product out of stock" do
    order = users(:benji).orders.build
    order.order_items.build(product: products(:cola), count: 10)

    order.save

    assert_includes order.errors[:base], "There is not enough stock for your order of the following products: Cola"
  end
end
