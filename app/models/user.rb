# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  debt_cents          :integer          default("0"), not null
#  nickname            :string
#  created_at          :datetime
#  updated_at          :datetime
#  encrypted_password  :string           default(""), not null
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
#

class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :rememberable, :trackable, :validatable

  has_paper_trail only: [:debt_cents, :admin, :orders_count, :koelkast]

  has_attached_file :avatar, styles: { large: "150x150>", medium: "100x100>", small: "40x40>" }, default_style: :medium

  has_many :orders, -> { includes :products }
  has_many :products, through: :orders
  belongs_to :dagschotel, class_name: 'Product'

  validates :nickname, presence: true, uniqueness: true
  validates_attachment :avatar,
    presence: true,
    content_type: { content_type: ["image/jpeg", "image/gif", "image/png"] }

  scope :members, -> { where koelkast: false }

  def debt
    self.debt_cents / 100.0
  end

  def debt=(value)
    if value.is_a? String then value.sub!(',', '.') end
    self.debt_cents = (value.to_f * 100).to_int
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
