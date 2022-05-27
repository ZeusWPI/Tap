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
  before do
    @barcode = create :barcode
  end

  it "has a valid factory" do
    expect(@barcode).to be_valid
  end

  ############
  #  FIELDS  #
  ############

  describe "fields" do
    describe "code" do
      it "is present" do
        @barcode.code = nil
        expect(@barcode).not_to be_valid
      end

      it "is unique" do
        barcode = build :barcode, code: @barcode.code
        expect(barcode).not_to be_valid
      end
    end
  end
end
