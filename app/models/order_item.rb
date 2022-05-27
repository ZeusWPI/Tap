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

class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :count, presence: true, numericality: { only_integer: true,
                                                    greater_than_or_equal_to: 0 }

  after_create :remove_from_stock!
  before_destroy :put_back_in_stock!

  private

  def remove_from_stock!
    product.decrement!(:stock, count)
  end

  def put_back_in_stock!
    product.increment!(:stock, count)
  end
end
