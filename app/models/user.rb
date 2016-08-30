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
#

class User < ApplicationRecord
  include Statistics, Avatarable, FriendlyId
  after_update :publish_changes

  friendly_id :name

  devise :omniauthable, omniauth_providers: [:zeuswpi]

  has_many :orders, -> { includes :product }
  has_many :products, through: :orders
  has_many :dagschotels

  scope :members, -> { where koelkast: false }
  scope :publik,  -> { where private: false }

  def self.from_omniauth(auth)
    where(name: auth.uid).first_or_create do |user|
      user.name = auth.uid
      user.avatar = Identicon.data_url_for auth.uid
    end
  end

  def calculate_frecency!
    num_orders = Rails.application.config.frecency_num_orders
    last_datetimes = self.orders.order(created_at: :desc)
                                .limit(num_orders)
                                .pluck(:created_at)
    self.frecency = last_datetimes.map(&:to_time).map(&:to_i).sum / num_orders
    self.save
  end

  def balance
    @balance || begin
      headers = {
        "Authorization" => "Token token=#{Rails.application.secrets.tab_api_key}",
        "Content-type" => "application/json"
      }
      result = HTTParty.get(
        File.join(Rails.application.config.api_url, "users", "#{name}.json"),
        headers: headers)

      if result.code == 200
        JSON.parse(result.body)["balance"].to_i
      else
        0
      end
    rescue
      0
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

  def channel
    "user_#{id}"
  end

  def publish_changes
    ActionCable.server.broadcast self.channel, { type: 'SET_USER', user: JSON.parse(
      UsersController.render(partial: 'users/show', locals: { user: self })
    ) }
  end
end
