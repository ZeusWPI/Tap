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
#  avatar_file_name    :string
#  avatar_content_type :string
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  orders_count        :integer          default(0)
#  koelkast            :boolean          default(FALSE)
#  name                :string
#  private             :boolean          default(FALSE)
#  frecency            :integer          default(0), not null
#  quickpay_hidden     :boolean
#

class User < ActiveRecord::Base
  include Statistics, Avatarable, FriendlyId
  friendly_id :name, use: :finders

  devise :omniauthable, :omniauth_providers => [:zeuswpi]

  has_many :orders, -> { includes :products }
  has_many :products, through: :orders
  belongs_to :dagschotel, class_name: 'Product'

  scope :members, -> { where koelkast: false }
  scope :publik,  -> { where private: false }

  def self.from_omniauth(auth)
    where(name: auth.uid).first_or_create do |user|
      user.name = auth.uid
      user.avatar = Identicon.data_url_for auth.uid
    end
  end

  def calculate_frecency
    num_orders = Rails.application.config.frecency_num_orders
    last_datetimes = self.orders.order(created_at: :desc)
                                .limit(num_orders)
                                .distinct
                                .pluck(:created_at)
    frequency = (last_datetimes.map(&:to_time).map(&:to_i).sum / (num_orders * 10))
    bonus = self.rich_privilige / 1.936
    self.frecency = frequency * bonus
    self.save
  end

  def rich_privilige
    Math.atan(self.balance / 10) + (Math::PI / 2)
  end

  def balance
    @balance || begin
      if Rails.env.test?
        12345
      else
        headers = {
          "Authorization" => "Token token=#{Rails.application.secrets.tab_api_key}",
          "Content-type" => "application/json"
        }
        result = HTTParty.get(File.join(Rails.application.config.api_url, "users", "#{name}.json"), headers: headers)

        if result.code == 200
          JSON.parse(result.body)["balance"]
        end
      end
    rescue
    end
  end

  # Static Users

  def self.guest
    @guest || find_or_create_by(name: "Guest") do |user|
      user.avatar = File.new(File.join("app", "assets", "images", "guest.png"))
    end
  end

  def guest?
    self == User.guest
  end

  def self.koelkast
    @koelkast || find_or_create_by(name: "Koelkast") do |user|
      user.avatar   = File.new(File.join("app", "assets", "images", "logo.png"))
      user.koelkast = true
    end
  end
end
