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

FactoryGirl.define do
  sequence :code, 1000

  factory :barcode do
    product
    code

    factory :invalid_barcode do
      code nil
    end
  end
end
