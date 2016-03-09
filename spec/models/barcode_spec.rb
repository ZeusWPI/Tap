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
  before :all do
    @barcode = create :barcode
  end

  before :each do
    @barcode.reload
  end

  it 'has a valid factory' do
    expect(@barcode).to be_valid
  end

  ############
  #  FIELDS  #
  ############

  describe 'fields' do
    describe 'code' do
      it 'should be present' do
        @barcode.code = nil
        expect(@barcode).to_not be_valid
      end

      it 'should be unique' do
        barcode = build :barcode, code: @barcode.code
        expect(barcode).to_not be_valid
      end
    end
  end
end
