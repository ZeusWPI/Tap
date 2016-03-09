# == Schema Information
#
# Table name: products
#
#  id                  :integer          not null, primary key
#  name                :string           not null
#  price_cents         :integer          default(0), not null
#  created_at          :datetime
#  updated_at          :datetime
#  avatar_file_name    :string
#  avatar_content_type :string
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  category            :integer          default(0)
#  stock               :integer          default(0), not null
#  calories            :integer
#  deleted             :boolean          default(FALSE)
#

class Product < ActiveRecord::Base
  include Avatarable

  has_many :barcodes, dependent: :destroy
  has_many :orders
  accepts_nested_attributes_for :barcodes

  enum category: %w(food beverages other)

  validates :name,        presence: true, uniqueness: true
  validates :price_cents, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :stock,       presence: true, numericality: { only_integer: true }
  validates :calories,    numericality: { only_integer: true, allow_nil: true, greater_than_or_equal_to: 0 }

  scope :for_sale, -> { where deleted: false }

  def price
    self.price_cents / 100.0
  end

  def price=(value)
    value.sub!(',', '.') if value.is_a? String
    self.price_cents = (value.to_f * 100).round
  end
end
