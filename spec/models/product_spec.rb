# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id                  :integer          not null, primary key
#  name                :string           not null
#  price_cents         :integer          default(0), not null
#  created_at          :datetime
#  updated_at          :datetime
#  avatar_file_name    :string
#  avatar_content_type :string
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  category            :integer          default(0)
#  stock               :integer          default(0), not null
#  calories            :integer
#  deleted             :boolean          default(FALSE)
#

describe Product do
  let(:product) { create :product }

  it "has a valid factory" do
    expect(product).to be_valid
  end

  ############
  #  FIELDS  #
  ############

  describe "fields" do
    describe "name" do
      it "is present" do
        product.name = nil
        expect(product).not_to be_valid
      end

      it "shold be unique" do
        expect(build(:product, name: product.name)).not_to be_valid
      end
    end

    describe "price_cents" do
      it "is present" do
        product.price_cents = nil
        expect(product).not_to be_valid
      end

      it "is a number" do
        product.price_cents = "123abc"
        expect(product).not_to be_valid
      end

      it "is strict positive" do
        product.price = -5
        expect(product).not_to be_valid
        product.price = 0
        expect(product).not_to be_valid
      end
    end

    describe "stock" do
      it "is present" do
        product.stock = nil
        expect(product).not_to be_valid
      end

      it "is a number" do
        product.stock = "123abc"
        expect(product).not_to be_valid
      end

      it "is positive" do
        product.stock = -5
        expect(product).not_to be_valid
        product.stock = 0
        expect(product).to be_valid
      end
    end

    describe "calories" do
      it "does not have to be present" do
        product.calories = nil
        expect(product).to be_valid
      end

      it "is a number" do
        product.calories = "123abc"
        expect(product).not_to be_valid
      end

      it "is positive" do
        product.calories = -5
        expect(product).not_to be_valid
      end
    end

    describe "avatar" do
      it "is present" do
        product.avatar = nil
        expect(product).not_to be_valid
      end
    end

    describe "deleted" do
      it "defaults false" do
        expect(product.deleted).to be false
      end
    end
  end

  #############
  #  METHODS  #
  #############

  describe "price" do
    it "reads the correct value" do
      expect(product.price).to eq(product.price_cents / 100.0)
    end

    it "writes the correct value" do
      product.price = 1.5
      product.save
      expect(product.reload.price_cents).to eq(150)
    end
  end

  ############
  #  SCOPES  #
  ############

  describe "for sale" do
    it "returns non-deleted products" do
      local_product = create :product
      local_product.update(deleted: true)
      expect(described_class.for_sale).to eq([product])
    end
  end
end
