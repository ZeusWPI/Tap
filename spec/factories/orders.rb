# == Schema Information
#
# Table name: orders
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  transaction_id :integer
#  product_id     :integer
#

require 'faker'

FactoryGirl.define do
  factory :order do
    user
    transient do
      products_count 1
    end
    before(:create) do |order, evaluator|
      order.order_items << create_list(:order_item, evaluator.products_count, order: order)
    end
  end
end
