require 'test_helper'

class ProductAttributesTest < ActiveSupport::TestCase
  test "product_attributes are read correctly" do
    params = {
      order_items_attributes: [
        {
          count: "5",
          product_attributes: {
            id: products(:fanta).id
          }
        }
      ]
    }

    o = Order.create(params)

    assert_equal o.order_items.first.product, products(:fanta)
  end
end
