# == Schema Information
#
# Table name: order_items
#
#  id         :integer          not null, primary key
#  order_id   :integer
#  product_id :integer          not null
#  count      :integer          default(0)
#

FactoryGirl.define do
  factory :order_item do
    order
    association :product, factory: :product
    count { 1 + rand(5) }
  end
end
