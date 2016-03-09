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
  # before :each do
    # @product = create :product
  # end

  # it 'has a valid factory' do
    # expect(@product).to be_valid
  # end

  # ############
  # #  FIELDS  #
  # ############

  # describe 'fields' do
    # describe 'name' do
      # it 'should be present' do
        # @product.name = nil
        # expect(@product).to_not be_valid
      # end

      # it 'shold be unique' do
        # expect(build :product, name: @product.name).to_not be_valid
      # end
    # end

    # describe 'price_cents' do
      # it 'should be present' do
        # @product.price_cents = nil
        # expect(@product).to_not be_valid
      # end

      # it 'should be a number' do
        # @product.price_cents = "123abc"
        # expect(@product).to_not be_valid
      # end

      # it 'should be strict positive' do
        # @product.price = -5
        # expect(@product).to_not be_valid
        # @product.price = 0
        # expect(@product).to_not be_valid
      # end
    # end

    # describe 'stock' do
      # it 'should be present' do
        # @product.stock = nil
        # expect(@product).to_not be_valid
      # end

      # it 'should be a number' do
        # @product.stock = "123abc"
        # expect(@product).to_not be_valid
      # end

      # it 'should be positive' do
        # @product.stock = -5
        # expect(@product).to_not be_valid
        # @product.stock = 0
        # expect(@product).to be_valid
      # end
    # end

    # describe 'calories' do
      # it 'does not have to be present' do
        # @product.calories = nil
        # expect(@product).to be_valid
      # end

      # it 'should be a number' do
        # @product.calories = "123abc"
        # expect(@product).to_not be_valid
      # end

      # it 'should be positive' do
        # @product.calories = -5
        # expect(@product).to_not be_valid
      # end
    # end

    # describe 'avatar' do
      # it 'should be present' do
        # @product.avatar = nil
        # expect(@product).to_not be_valid
      # end
    # end

    # describe 'deleted' do
      # it 'should default false' do
        # expect(@product.deleted).to be false
      # end
    # end
  # end

  # #############
  # #  METHODS  #
  # #############

  # describe 'price' do
    # it 'should read the correct value' do
      # expect(@product.price).to eq(@product.price_cents / 100.0)
    # end

    # it 'should write the correct value' do
      # @product.price = 1.5
      # @product.save
      # expect(@product.reload.price_cents).to eq(150)
    # end
  # end

  # ############
  # #  SCOPES  #
  # ############

  # describe 'for sale' do
    # it 'should return non-deleted products' do
      # product = create :product
      # product.update_attribute(:deleted, true)
      # expect(Product.for_sale).to eq([@product])
    # end
  # end
end
