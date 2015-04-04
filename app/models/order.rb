# == Schema Information
#
# Table name: orders
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  price_cents :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  cancelled   :boolean          default("f")
#

class Order < ActiveRecord::Base
  include ActionView::Helpers::TextHelper

  after_create     { self.user.increment!(:debt_cents, price_cents) }

  belongs_to :user, counter_cache: true
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  scope :active, -> { where(cancelled: false) }

  validates :user, presence: true
  validates :order_items, presence: true, in_stock: true

  accepts_nested_attributes_for :order_items, reject_if: proc { |oi| oi[:count].to_i <= 0 }

  def price_cents
    self.order_items.map{ |oi| oi.count * oi.product.price_cents }.sum
  end

  def price
    self.price_cents / 100.0
  end

  def price=(_)
    write_attribute(:price_cents, price_cents)
  end

  def cancel
    return if self.cancelled
    user.decrement!(:debt_cents, price_cents)
    User.decrement_counter(:orders_count, user.id)
    update_attribute(:cancelled, true)
    self.order_items.each(&:cancel)
  end

  def to_sentence
    self.order_items.map {
      |oi| pluralize(oi.count, oi.product.name)
    }.to_sentence
  end

  def g_order_items(products)
    products.each do |p|
      if (oi = self.order_items.select { |t| t.product == p }).size > 0
        oi.first.count = [oi.first.product.stock, oi.first.count].min
      else
        self.order_items.build(product: p)
      end
    end
  end
end
