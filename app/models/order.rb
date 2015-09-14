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
  validates :order_items, presence: true
  validates :price_cents, presence: true
  validates_associated :order_items

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
      priority = 0
      run_at   = Rails.application.config.call_api_after.from_now
      job      = TabApiJob.new(id)

      Delayed::Job.enqueue job, priority, run_at
    end
end
