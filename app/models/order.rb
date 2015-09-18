# == Schema Information
#
# Table name: orders
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  price_cents    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  transaction_id :integer
#

class Order < ActiveRecord::Base
  include ActionView::Helpers::TextHelper

  belongs_to :user, counter_cache: true
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  before_validation :calculate_price
  before_save { |o| o.order_items = o.order_items.reject{ |oi| oi.count == 0 } }
  after_create :create_api_job

  validates :user, presence: true
  validates_associated :order_items
  validate :product_presence

  accepts_nested_attributes_for :order_items

  def to_sentence
    self.order_items.map {
      |oi| pluralize(oi.count, oi.product.name)
    }.to_sentence
  end

  private

    def calculate_price
      self.price_cents = self.order_items.map{ |oi| oi.count * oi.product.price_cents }.sum
    end

    def create_api_job
      return if Rails.env.test?

      priority = 0
      run_at   = Rails.application.config.call_api_after.from_now
      job      = TabApiJob.new(id)

      Delayed::Job.enqueue job, priority: priority, run_at: run_at
    end

    def product_presence
      errors.add(:base, "You have to order at least one product.") if order_items.map(&:count).sum.zero?
    end
end
