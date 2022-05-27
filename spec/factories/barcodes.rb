# frozen_string_literal: true

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

FactoryBot.define do
  factory :barcode do
    product
    sequence :code

    factory :invalid_barcode do
      code { nil }
    end
  end
end
