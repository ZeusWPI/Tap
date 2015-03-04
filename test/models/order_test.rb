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
  def setup
    @order = Order.new
    @order.order_items.build(product: products(:fanta), count: 1)
    @order.order_items.build(product: products(:bueno), count: 2)
  end

  test "order total price is correct" do
    assert_equal @order.price, 300
  end

  test "to_sentence is correct" do
    assert_equal @order.to_sentence, "1 Fanta and 2 Kinder Buenos"
  end
end
