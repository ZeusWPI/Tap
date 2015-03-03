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
  after_create     { self.user.increment!(:balance_cents, -price) }
  before_destroy   { self.user.increment!(:balance_cents, price) }

  belongs_to :user, counter_cache: true
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  attr_accessor :total_price

  validates :user, presence: true
  validates :order_items, presence: true, in_stock: true

  accepts_nested_attributes_for :order_items, reject_if: proc { |oi| oi[:count].to_i <= 0 }

  def price
    self.order_items.map{ |oi| oi.count * oi.product.price_cents }.sum
  end

  def to_sentence
    self.order_items.map {
      |oi| pluralize(oi.count, oi.product.name)
    }.to_sentence
  end

  def g_order_items(products, params = {})
    products.each do |p|
      if (oi = self.order_items.select { |t| t.product == p }).size > 0
        oi.first.count = [oi.first.product.stock, oi.first.count].min
      else
        self.order_items.build(product: p)
      end
    end
  end
end
