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
  validates :count, presence: true, numericality: { only_integer: true, greater_than: 0 }

  after_create :remove_from_stock

  accepts_nested_attributes_for :product

  def product_attributes=(attributes)
    self.product = Product.find(attributes[:id])
    super
  end

  def cancel
    self.product.increment!(:stock, self.count)
  end

  private

    def remove_from_stock
      product.decrement!(:stock, count)
    end
end
