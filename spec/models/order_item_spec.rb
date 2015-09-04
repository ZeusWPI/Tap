describe OrderItem do
  it 'has a valid factory' do
    order_item = create :order_item
    expect(order_item).to be_valid
  end

  describe 'validations' do
    before :each do
      @order_item = create :order_item
    end

    it 'product should be present' do
      @order_item.product = nil
      expect(@order_item).to_not be_valid
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
    end
  end

  describe 'product stock' do
    before :each do
      @product = create :product
      @count = rand 10
      @order_item = build :order_item, product: @product, count: @count
    end

    it 'should decrement on create' do
      expect{@order_item.save}.to change{@product.stock}.by(-@count)
    end

    it 'should increment on cancel' do
      @order_item.save
      expect{@order_item.cancel}.to change{@product.stock}.by(@count)
    end
  end
end
