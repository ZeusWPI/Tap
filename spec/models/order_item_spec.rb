# == Schema Information
#
# Table name: order_items
#
#  id         :integer          not null, primary key
#  order_id   :integer
#  product_id :integer          not null
#  count      :integer          default(0)
#

describe OrderItem do
  before do
    stub_request(:get, /.*/).to_return(status: 200, body: JSON.dump({ balance: 20 }))
  end

  it "has a valid factory" do
    order_item = create :order_item
    expect(order_item).to be_valid
  end

  ############
  #  FIELDS  #
  ############

  describe "fields" do
    before do
      @order_item = create :order_item
    end

    describe "product" do
      it "is present" do
        @order_item.product = nil
        expect(@order_item).not_to be_valid
      end
    end

    describe "count" do
      it "is present" do
        @order_item.count = nil
        expect(@order_item).not_to be_valid
      end

      it "is positive" do
        @order_item.count = -5
        expect(@order_item).not_to be_valid
      end

      # Stock is not up to date
      # it 'should be less or equal to product stock' do
      #   @order_item.count = @order_item.product.stock + 1
      #   expect(@order_item).to_not be_valid
      #   @order_item.count = [@order_item.product.stock, 100].min
      #   expect(@order_item).to be_valid
      # end
    end
  end

  ###############
  #  CALLBACKS  #
  ###############

  describe "stock change" do
    before do
      @product = create :product
      @count = rand 10
      @order_item = build :order_item, product: @product, count: @count
    end

    it "decrements on create" do
      expect { @order_item.save }.to change { @product.stock }.by(-@count)
    end

    it "increments on destroy" do
      @order_item.save
      expect { @order_item.destroy }.to change { @product.stock }.by(@count)
    end
  end
end
