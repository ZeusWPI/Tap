# == Schema Information
#
# Table name: order_items
#
#  id         :integer          not null, primary key
#  order_id   :integer
#  product_id :integer          not null
#  count      :integer          default("0")
#

describe OrderItem do
  it 'has a valid factory' do
    order_item = create :order_item
    expect(order_item).to be_valid
  end

  ############
  #  FIELDS  #
  ############

  describe 'fields' do
    before :each do
      @order_item = create :order_item
    end

    describe 'product' do
      it 'should be present' do
        @order_item.product = nil
        expect(@order_item).to_not be_valid
      end
    end

    describe 'count' do
      it 'should be present' do
        @order_item.count = nil
        expect(@order_item).to_not be_valid
      end

      it 'should be positive' do
        @order_item.count = -5
        expect(@order_item).to_not be_valid
      end

      it 'should be less or equal to product stock' do
        @order_item.count = @order_item.product.stock + 1
        expect(@order_item).to_not be_valid
        @order_item.count = [@order_item.product.stock, 100].min
        expect(@order_item).to be_valid
      end
    end
  end

  ###############
  #  CALLBACKS  #
  ###############

  describe 'stock change' do
    before :each do
      @product = create :product
      @count = rand 10
      @order_item = build :order_item, product: @product, count: @count
    end

    it 'should decrement on create' do
      expect{ @order_item.save }.to change{ @product.stock }.by(-@count)
    end

    it 'should increment on destroy' do
      @order_item.save
      expect{ @order_item.destroy }.to change{ @product.stock }.by(@count)
    end
  end
end
