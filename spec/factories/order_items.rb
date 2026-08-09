# frozen_string_literal: true

# == Schema Information
#
# Table name: order_items
#
#  id         :integer          not null, primary key
#  count      :integer          default(0)
#  order_id   :integer          not null
#  product_id :integer          not null
#
# Foreign Keys
#
#  order_id    (order_id => orders.id)
#  product_id  (product_id => products.id)
#

FactoryBot.define do
  factory :order_item do
    order
    product factory: %i[product]
    count { rand(1..5) }
  end
end
