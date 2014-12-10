# == Schema Information
#
# Table name: products
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  price               :integer
#  created_at          :datetime
#  updated_at          :datetime
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#

class Product < ActiveRecord::Base
  has_many :order_products
  has_attached_file :avatar, styles: { medium: "100x100>" }, default_style: :medium

  validates :name, presence: true
  validates :price, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates_attachment :avatar, presence: true, content_type: { content_type: ["image/jpeg", "image/gif", "image/png"] },
    default_url: "http://babeholder.pixoil.com/img/190/190"

  def count(order)
    order_products.find_by(order: order).count
  end

  def price
    (read_attribute(:price) || 0) / 100.0
  end

  def price=(value)
    if value.is_a? String then value.sub!(',', '.') end
    write_attribute(:price, (value.to_f * 100).to_int)
  end

end
