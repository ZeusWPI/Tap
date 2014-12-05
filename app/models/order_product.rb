# == Schema Information
#
# Table name: order_products
#
#  id         :integer          not null, primary key
#  order_id   :integer
#  product_id :integer
#  count      :integer          default(1)
#

class OrderProduct < ActiveRecord::Base
  belongs_to :order
  belongs_to :product

  validates :product, presence: true
  validates :count, numericality: { greater_than_or_equal_to: 0 }

  accepts_nested_attributes_for :product
end
