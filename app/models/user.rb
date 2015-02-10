# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  last_name           :string(255)
#  balance_cents       :integer          default(0), not null
#  nickname            :string(255)
#  admin               :boolean
#  koelkast            :boolean          default(FALSE)
#  dagschotel_id       :integer
#  orders_count        :integer          default(0)
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  created_at          :datetime
#  updated_at          :datetime
#  encrypted_password  :string(255)      default(""), not null
#  remember_created_at :datetime
#  sign_in_count       :integer          default(0), not null
#  current_sign_in_at  :datetime
#  last_sign_in_at     :datetime
#  current_sign_in_ip  :string(255)
#  last_sign_in_ip     :string(255)
#

class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :rememberable, :trackable, :validatable

  has_paper_trail only: [:balance, :admin, :orders_count, :koelkast]

  has_attached_file :avatar, styles: { medium: "100x100>" }, default_style: :medium, default_url: "http://lorempixel.com/70/70/"

  has_many :orders, -> { includes :products }
  has_many :products, through: :orders
  belongs_to :dagschotel, class_name: 'Product'

  validates :nickname, presence: true, uniqueness: true
  validates_attachment :avatar, content_type: { content_type: ["image/jpeg", "image/gif", "image/png"] }
  # validates_attachment :avatar, presence: true

  scope :members, -> { where koelkast: false }

  def full_name
    "#{name} #{last_name}"
  end

  def balance
    self.balance_cents / 100.0
  end

  def balance=(value)
    if value.is_a? String then value.sub!(',', '.') end
    self.balance_cents = (value.to_f * 100).to_int
  end

  # Change URL params for User

  def to_param
    "#{id} #{nickname}".parameterize
  end

  # This is needed so Devise doesn't try to validate :email

  def email_required?
    false
  end

  def email_changed?
    false
  end
end
