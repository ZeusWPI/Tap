# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  created_at          :datetime
#  updated_at          :datetime
#  remember_created_at :datetime
#  admin               :boolean          default(FALSE)
#  dagschotel_id       :integer
#  orders_count        :integer          default(0)
#  koelkast            :boolean          default(FALSE)
#  name                :string
#  private             :boolean          default(FALSE)
#  frecency            :integer          default(0), not null
#  quickpay_hidden     :boolean          default(FALSE)
#  userkey             :string
#  zauth_id            :string
#

class User < ApplicationRecord
  include FriendlyId
  include Statistics

  friendly_id :name, use: :finders

  devise :omniauthable, omniauth_providers: [:zeuswpi]

  has_many :orders, -> { includes :products }, inverse_of: :user, dependent: :restrict_with_error
  has_many :products, through: :orders
  belongs_to :dagschotel, class_name: "Product", optional: true

  scope :members, -> { where koelkast: false }
  scope :publik, -> { where private: false }

  def self.from_omniauth(auth)
    db_user = find_by(zauth_id: auth.uid)

    if db_user.nil?
      db_user = find_or_create_by!(name: auth.extra.raw_info["username"]) do |user|
        user.generate_key!
        user.private = true
      end

      db_user.zauth_id = auth.uid
    end

    # overwrite name (for if name changed)
    db_user.name = auth.extra.raw_info["username"]

    # get roles info
    roles = auth.dig(:extra, :raw_info, :roles) || []

    admin_roles = %w[bestuur tap_admin]
    db_user.admin = roles.intersect?(admin_roles)

    db_user.save! if db_user.changed?

    db_user
  end

  def calculate_frecency
    num_orders = Rails.application.config.frecency_num_orders
    last_datetimes = orders.order(created_at: :desc)
                           .limit(num_orders)
                           .distinct
                           .pluck(:created_at)

    # The frequency is determined by the most recent orders
    frequency = (last_datetimes.map(&:to_time).map(&:to_i).sum / (num_orders * 10))

    # The higher the user's balance, the higher the ranking.
    bonus = rich_privilege / 1.936

    # Calculate the frecency
    self.frecency = frequency * bonus
    save
  end

  # Users with more money rank higher in the list on Koelkast
  def rich_privilege
    Math.atan(balance / 10) + (Math::PI / 2)
  end

  # Get the users balance
  def balance
    # If in development, return a mocked amount
    return 1234 if Rails.env.development?

    # If in production, fetch the user's balance from Tab.
    bal = @balance || begin
      headers = {
        "Authorization" => "Token token=#{Rails.application.secrets.tab_api_key}",
        "Content-type" => "application/json"
      }
      result = HTTParty.get(File.join(Rails.application.config.api_url, "users", "#{name}.json"), headers: headers)

      JSON.parse(result.body)["balance"] if result.code == 200
    rescue StandardError => e
      raise "Error fetching balance from Tab: #{e}"
    end

    return nil if bal.nil?

    # Subtract pending orders to avoid negative balance
    pending_orders = orders.pending
    total_pending = pending_orders.map(&:calculate_price).sum || 0

    bal - total_pending
  end

  def last_ordered_products(amount = 5)
    products = orders.includes(:products)
                     .order(created_at: :desc)
                     .limit(amount + 15)
                     .flat_map(&:products)

    products.tally
            .sort_by { |_, count| -count }
            .map(&:first)
            .first(amount)
  end

  def avatar
    Rails.application.config.zpi_image_url + (zauth_id || 0).to_s
  end

  # Static Users

  def self.guest
    @guest || find_or_create_by(name: "Guest")
  end

  def guest?
    self == User.guest
  end

  def self.koelkast
    @koelkast || find_or_create_by(name: "Koelkast") do |user|
      user.koelkast = true
    end
  end

  def generate_key
    set_key unless userkey
  end

  def generate_key!
    set_key
    save
  end

  private

  def set_key
    self.userkey = SecureRandom.base64(18)
  end
end
