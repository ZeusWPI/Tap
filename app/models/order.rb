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
  include ActionView::Helpers::TextHelper

  after_initialize { self.total_price = 0 }
  after_create { self.user.pay(price) }

  belongs_to :user, counter_cache: true
  has_many :order_products
  has_many :products, through: :order_products

  attr_accessor :total_price

  validates :user, presence: true
  validates :order_products, presence: true, in_stock: true

  accepts_nested_attributes_for :order_products, reject_if: proc { |op| op[:count].to_i <= 0 }

  def price
    self.order_products.map{ |op| op.count * op.product.price }.sum
  end

  def to_sentence
    self.order_products.map {
      |op| pluralize(op.count, op.product.name)
    }.to_sentence
  end
end
