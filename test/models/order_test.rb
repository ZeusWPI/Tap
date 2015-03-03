# == Schema Information
#
# Table name: orders
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  cost       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  test "order total price is correct" do
    o = Order.new
    o.order_items.build(product: products(:fanta), count: 1)
    o.order_items.build(product: products(:bueno), count: 2)
    assert_equal o.price, 300
  end
end
