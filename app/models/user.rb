# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  created_at          :datetime
#  updated_at          :datetime
#  remember_created_at :datetime
#  sign_in_count       :integer          default("0"), not null
#  current_sign_in_at  :datetime
#  last_sign_in_at     :datetime
#  current_sign_in_ip  :string
#  last_sign_in_ip     :string
#  admin               :boolean
#  dagschotel_id       :integer
#  avatar_file_name    :string
#  avatar_content_type :string
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  orders_count        :integer          default("0")
#  koelkast            :boolean          default("f")
#  provider            :string
#  uid                 :string
#  encrypted_password  :string           default(""), not null
#  private             :boolean          default("f")
#

require 'identicon'
class User < ActiveRecord::Base
  devise :database_authenticatable, :trackable, :omniauthable, :omniauth_providers => [:zeuswpi]

  has_paper_trail
  has_attached_file :avatar, styles: { large: "150x150>", medium: "100x100>", small: "40x40>" }, default_style: :medium
  has_many :orders, -> { includes :products }
  has_many :products, through: :orders
  belongs_to :dagschotel, class_name: 'Product'

  validates_attachment :avatar,
    presence: true,
    content_type: { content_type: ["image/jpeg", "image/gif", "image/png"] }

  scope :members, -> { where koelkast: false }
  scope :publik, -> { where private: false }

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.avatar = Identicon.data_url_for auth.uid
    end
  end

  def nickname
    self.uid
  end

  def debt
    42.15
  end

  # Change URL params for User

  def to_param
    "#{id} #{nickname}".parameterize
  end
end
