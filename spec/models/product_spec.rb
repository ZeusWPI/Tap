# == Schema Information
#
# Table name: products
#
#  id                  :integer          not null, primary key
#  name                :string           not null
#  price_cents         :integer          default("0"), not null
#  created_at          :datetime
#  updated_at          :datetime
#  avatar_file_name    :string
#  avatar_content_type :string
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  category            :integer          default("0")
#  stock               :integer          default("0"), not null
#  calories            :integer
#  deleted             :boolean          default("f")
#

describe Product do
  before :each do
    @product = create :product
  end

  it 'has a valid factory' do
    expect(@product).to be_valid
  end

  describe 'validations' do
    it 'name should be present' do
      @product.name = ''
      expect(@product).to_not be_valid
    end

    describe 'price' do
      it 'should be positive' do
        @product.price = -5
        expect(@product).to_not be_valid
      end

      it 'should be saved correctly' do
        @product.price = 1.20
        @product.save
        expect(@product.reload.price).to eq(1.20)
        expect(@product.reload.price_cents).to eq(120)
      end
    end

    describe 'stock' do
      it 'should be present' do
        @product.stock = nil
        expect(@product).to_not be_valid
      end

      it 'should be positive' do
        @product.stock = -5
        expect(@product).to_not be_valid
      end
    end

    describe 'calories' do
      it 'should not be present' do
        @product.calories = nil
        expect(@product).to be_valid
      end

      it 'should be positive' do
        @product.calories = -5
        expect(@product).to_not be_valid
      end
    end

    it 'avatar should be present' do
      @product.avatar = nil
      expect(@product).to_not be_valid
    end
  end
end
