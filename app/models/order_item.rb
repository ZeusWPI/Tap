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
  validates :count, presence: true, numericality: { only_integer: true,
                                                    less_than_or_equal_to: ->(oi) { oi.product.try(:stock) || 100 },
                                                    greater_than_or_equal_to: 0 }

  before_destroy :put_back_in_stock!
  after_create :remove_from_stock!

  accepts_nested_attributes_for :product

  def product_attributes=(attributes)
    self.product = OrderItem.products.select{ |p| p.id == attributes[:id].to_i }.first
    super
  end

  def self.products
    @products || Product.all
  end

  private

    def remove_from_stock!
      product.decrement!(:stock, count)
    end

    def put_back_in_stock!
      product.increment!(:stock, self.count)
    end
end
