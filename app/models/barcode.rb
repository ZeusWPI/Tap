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

class Barcode < ApplicationRecord
  include FriendlyId

  friendly_id :code, use: :finders

  belongs_to :product

  validates :code, presence: true, uniqueness: true # rubocop:disable Rails/UniqueValidationWithoutIndex
end
