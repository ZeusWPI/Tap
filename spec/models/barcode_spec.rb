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

describe Barcode do
  let(:barcode) { create(:barcode) }

  it "has a valid factory" do
    expect(barcode).to be_valid
  end

  ############
  #  FIELDS  #
  ############

  describe "fields" do
    describe "code" do
      it "is present" do
        barcode.code = nil
        expect(barcode).not_to be_valid
      end

      it "is unique" do
        local_barcode = build(:barcode, code: barcode.code)
        expect(local_barcode).not_to be_valid
      end
    end
  end
end
