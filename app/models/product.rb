# == Schema Information
#
# Table name: products
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  purchase_price :integer
#  sale_price     :integer
#  img_path       :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

class Product < ActiveRecord::Base
  has_one :order_product

  validates :name, presence: true
  validates :purchase_price, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :sale_price, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
