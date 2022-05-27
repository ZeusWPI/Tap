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

describe Barcode do
  let(:barcode) { create :barcode }

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
        local_barcode = build :barcode, code: barcode.code
        expect(local_barcode).not_to be_valid
      end
    end
  end
end
