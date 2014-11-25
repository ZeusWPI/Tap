class User < ActiveRecord::Base
  has_many :orders

  validates :name, presence: true
  validates :last_name, presence: true
  validates :nickname, presence: true, uniqueness: true

  def full_name
    "#{name} #{last_name}"
  end

  has_secure_password
end
