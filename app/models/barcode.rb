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

class Barcode < ApplicationRecord
  include FriendlyId
  friendly_id :code, use: :finders

  belongs_to :product

  validates :code, presence: true, uniqueness: true # rubocop:disable Rails/UniqueValidationWithoutIndex
end
