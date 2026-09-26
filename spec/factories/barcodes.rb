# frozen_string_literal: true

# == Schema Information
#
# Table name: barcodes
#
#  id         :integer          not null, primary key
#  code       :string           default(""), not null
#  created_at :datetime
#  updated_at :datetime
#  product_id :integer          not null
#
# Indexes
#
#  index_barcodes_on_code  (code)
#
# Foreign Keys
#
#  product_id  (product_id => products.id)
#

FactoryBot.define do
  factory :barcode do
    product
    sequence :code

    factory :invalid_barcode do
      code { nil }
    end
  end
end
