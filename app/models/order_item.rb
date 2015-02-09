# == Schema Information
#
# Table name: order_items
#
#  id         :integer          not null, primary key
#  order_id   :integer          not null
#  product_id :integer          not null
#  count      :integer          default(0)
#

class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product

  validates :product, presence: true
  validates :count,   numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  after_create :remove_from_stock
  before_destroy :put_back_in_stock

  accepts_nested_attributes_for :product

  def product_attributes=(attributes)
    self.product = Product.find(attributes[:id])
    super
  end

  private

    def remove_from_stock
      product.increment!(:stock, - self.count)
    end

    def put_back_in_stock
      product.increment!(:stock, self.count)
    end
end
