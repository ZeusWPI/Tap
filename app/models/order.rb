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
  include ApplicationHelper

  belongs_to :user, counter_cache: true
  belongs_to :product

  after_create  :create_api_job, unless: -> { user.guest? }
  after_create  :update_user_frecency!
  after_destroy :update_user_frecency!
  after_create :remove_from_stock!
  before_destroy :put_back_in_stock!

  validates :user,    presence: true
  validates :product, presence: true
  validates :method,  presence: true

  scope :after, ->(date) { where 'created_at > ?', date }

  def deletable
    self.created_at > Rails.application.config.call_api_after.ago
  end

  def day
    self.created_at.to_date
  end

  private

    def create_api_job
      return if Rails.env.test? || method == 'cash'

      priority = 0
      run_at   = Rails.application.config.call_api_after.from_now
      job      = TabApiJob.new(id)

      Delayed::Job.enqueue job, priority: priority, run_at: run_at
    end

    def update_user_frecency!
      user.calculate_frecency!
    end

    def remove_from_stock!
      product.decrement!(:stock)
    end

    def put_back_in_stock!
      product.increment!(:stock)
    end
end
