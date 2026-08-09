# frozen_string_literal: true

# == Schema Information
#
# Table name: orders
#
#  id             :integer          not null, primary key
#  price_cents    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  transaction_id :integer
#  user_id        :integer          not null
#
# Indexes
#
#  index_orders_on_created_at              (created_at)
#  index_orders_on_user_id                 (user_id)
#  index_orders_on_user_id_and_created_at  (user_id,created_at)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#

require "faker"

FactoryBot.define do
  factory :order do
    user
    transient do
      products_count { 1 }
    end
    before(:create) do |order, evaluator|
      order.order_items << build_list(:order_item, evaluator.products_count, order: order)
    end
  end
end
