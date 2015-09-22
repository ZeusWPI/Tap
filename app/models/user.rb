# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  created_at          :datetime
#  updated_at          :datetime
#  remember_created_at :datetime
#  admin               :boolean
#  dagschotel_id       :integer
#  avatar_file_name    :string
#  avatar_content_type :string
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  orders_count        :integer          default("0")
#  koelkast            :boolean          default("f")
#  name                :string
#  encrypted_password  :string           default(""), not null
#  private             :boolean          default("f")
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

  def balance
    @balance || begin
      headers = {
        "Authorization" => "Token token=#{Rails.application.secrets.tab_api_key}",
        "Content-type" => "application/json"
      }
      result = HTTParty.get(File.join(Rails.application.config.api_url, "users", "#{name}.json"), headers: headers)

      if result.code == 200
        JSON.parse(result.body)["balance"]
      else
        0
      end
    end
  end
end
