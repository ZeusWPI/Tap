# == Schema Information
#
# Table name: orders
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  cost       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Order < ActiveRecord::Base
  after_initialize { self.total_price = 0 }
  after_create :pay_price

  belongs_to :user, counter_cache: true
  has_many :order_products
  has_many :products, through: :order_products

  attr_accessor :total_price

  validates :user, presence: true
  validates :order_products, presence: true

  accepts_nested_attributes_for :order_products, reject_if: proc { |op| op[:count].to_i <= 0 }

  def price
    price = 0
    order_products.each do |op|
      price += op.count * op.product.read_attribute(:price)
    end
    price
  end

  private

    def pay_price
      user.pay(price)
    end
end
