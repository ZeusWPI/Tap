# frozen_string_literal: true

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
class Order < ApplicationRecord
  include ApplicationHelper
  include ActionView::Helpers::TextHelper

  belongs_to :user, counter_cache: true
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  before_validation :calculate_price
  before_save { |o| o.order_items = o.order_items.reject { |oi| oi.count.zero? } }
  after_create :create_api_job, unless: -> { user.guest? }

  after_create :update_user_frecency
  after_destroy :update_user_frecency

  validates_associated :order_items
  validate :product_presence

  accepts_nested_attributes_for :order_items

  scope :pending, -> { where(created_at: Rails.application.config.call_api_after.ago..) }
  scope :final, -> { where(created_at: ..Rails.application.config.call_api_after.ago) }

  def to_sentence
    order_items.map do |oi|
      pluralize(oi.count, oi.product.name)
    end.to_sentence
  end

  def deletable
    Time.zone.now <= deletable_until
  end

  def deletable_until
    created_at + Rails.application.config.call_api_after
  end

  def sec_until_remove
    (deletable_until - Time.zone.now).to_i
  end

  def calculate_price
    self.price_cents = order_items.map { |oi| oi.count * (oi.product.try(:price_cents) || 0) }.sum
  end

  private

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

  def update_user_frecency
    user.calculate_frecency
  end
end
