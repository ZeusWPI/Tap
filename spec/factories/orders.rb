# == Schema Information
#
# Table name: orders
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  price_cents :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  cancelled   :boolean          default("f")
#

require 'faker'

FactoryGirl.define do
  factory :order do
    user
    before(:create) do |order|
      order.order_items << build(:order_item, order: order)
    end
  end
end
