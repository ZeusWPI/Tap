# == Schema Information
#
# Table name: order_items
#
#  id         :integer          not null, primary key
#  order_id   :integer
#  product_id :integer          not null
#  count      :integer          default("0")
#

class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product

  validates :product, presence: true
  validates :count,   presence: true, numericality: { only_integer: true }

  before_destroy :put_back_in_stock!
  after_create :remove_from_stock!

  private

    def remove_from_stock!
      product.decrement!(:stock, count)
    end

    def put_back_in_stock!
      product.increment!(:stock, self.count)
    end
end
