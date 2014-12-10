# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  last_name           :string(255)
#  balance             :integer          default(0)
#  nickname            :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  encrypted_password  :string(255)      default(""), not null
#  remember_created_at :datetime
#  sign_in_count       :integer          default(0), not null
#  current_sign_in_at  :datetime
#  last_sign_in_at     :datetime
#  current_sign_in_ip  :string(255)
#  last_sign_in_ip     :string(255)
#  dagschotel          :reference
#  dagschotel_id       :integer
#

class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable
  has_attached_file :avatar, styles: { medium: "100x100>" }, default_style: :medium, default_url: "http://babeholder.pixoil.com/img/70/70"

  has_many :orders, -> { includes :products }
  belongs_to :dagschotel, class_name: 'Product'

  validates :nickname, presence: true, uniqueness: true
  validates :name, presence: true
  validates :last_name, presence: true
  validates :password, length: { in: 8..128 }, confirmation: true, on: :create
  validates_attachment :avatar, presence: true, content_type: { content_type: ["image/jpeg", "image/gif", "image/png"] }

  def full_name
    "#{name} #{last_name}"
  end

  def pay(amount)
    self.increment!(:balance, - amount)
  end
end
