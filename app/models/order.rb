# == Schema Information
#
# Table name: orders
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  price_cents    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  cancelled      :boolean          default("f")
#  transaction_id :integer
#

require 'httparty'
class Order < ActiveRecord::Base
  include ActionView::Helpers::TextHelper

  belongs_to :user, counter_cache: true
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  before_validation :calculate_price
  before_save { |o| o.order_items = o.order_items.reject{ |oi| oi.count == 0 } }
  after_create { Delayed::Job.enqueue TabApiJob.new(id) }

  default_scope -> { where(cancelled: false) }

  validates :user, presence: true
  validates :order_items, presence: true, in_stock: true
  validates :price_cents, presence: true

  accepts_nested_attributes_for :order_items

  def cancel
    return false if cancelled || created_at < 5.minutes.ago

    User.decrement_counter(:orders_count, user.id)
    update_attribute(:cancelled, true)
    self.order_items.each(&:cancel)
    tab_api_cancelled
    true
  end

  def to_sentence
    self.order_items.map {
      |oi| pluralize(oi.count, oi.product.name)
    }.to_sentence
  end

  def g_order_items(products)
    products.each do |p|
      self.order_items.build(product: p)
    end
  end

  private

  def calculate_price
    self.price_cents = self.order_items.map{ |oi| oi.count * oi.product.price_cents }.sum
  end
end
