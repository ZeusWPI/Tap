# == Schema Information
#
# Table name: products
#
#  id                  :integer          not null, primary key
#  name                :string           not null
#  price_cents         :integer          default("0"), not null
#  created_at          :datetime
#  updated_at          :datetime
#  avatar_file_name    :string
#  avatar_content_type :string
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  category            :integer          default("0")
#  stock               :integer          default("0"), not null
#  calories            :integer
#  deleted             :boolean          default("f")
#

class Product < ActiveRecord::Base
  include Avatarable

  has_many :order_items
  has_many :barcodes, dependent: :destroy
  accepts_nested_attributes_for :barcodes

  enum category: %w(food beverages other)

  validates :name,        presence: true, uniqueness: true
  validates :price_cents, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :stock,       presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :calories,    numericality: { only_integer: true, allow_nil: true, greater_than_or_equal_to: 0 }

  scope :for_sale, -> { where deleted: false }

  def price
    self.price_cents / 100.0
  end

  def price=(value)
    if value.is_a? String then value.sub!(',', '.') end
    self.price_cents = (value.to_f * 100).to_int
  end
end
