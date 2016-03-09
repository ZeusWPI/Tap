# == Schema Information
#
# Table name: orders
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  transaction_id :integer
#  product_id     :integer
#

class Order < ActiveRecord::Base
  include ActionView::Helpers::TextHelper, ApplicationHelper

  belongs_to :user, counter_cache: true
  belongs_to :product

  after_create  :create_api_job, unless: -> { user.guest? }
  after_create  :update_user_frecency
  after_destroy :update_user_frecency

  validates :user,    presence: true
  validates :product, presence: true

  def flash_success
    f = "#{to_sentence} ordered."
    f << " Please put #{euro_from_cents(price_cents)} in our pot!" if user.guest?
    f << " Enjoy it!"
  end

  def deletable
    self.created_at > Rails.application.config.call_api_after.ago
  end

  private

    def calculate_price
      self.price_cents = self.order_items.map{ |oi| oi.count * (oi.product.try(:price_cents) || 0) }.sum
    end

    def create_api_job
      return if Rails.env.test?

      priority = 0
      run_at   = Rails.application.config.call_api_after.from_now
      job      = TabApiJob.new(id)

      Delayed::Job.enqueue job, priority: priority, run_at: run_at
    end

    def update_user_frecency
      self.user.calculate_frecency
    end
end
