# frozen_string_literal: true

# == Schema Information
#
# Table name: order_items
#
#  id         :integer          not null, primary key
#  order_id   :integer
#  product_id :integer          not null
#  count      :integer          default(0)
#

FactoryBot.define do
  factory :order_item do
    order
    product factory: %i[product]
    count { rand(1..5) }
  end
end
