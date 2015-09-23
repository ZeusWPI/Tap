# == Schema Information
#
# Table name: barcodes
#
#  id         :integer          not null, primary key
#  product_id :integer
#  code       :string           default(""), not null
#  created_at :datetime
#  updated_at :datetime
#

class Barcode < ActiveRecord::Base
  belongs_to :product

  validates :product, presence: true
  validates :code, uniqueness: true
end
