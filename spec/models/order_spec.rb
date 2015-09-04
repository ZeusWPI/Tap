# == Schema Information
#
# Table name: orders
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  price_cents :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  cancelled   :boolean          default("f")
#

describe Order do
  before :each do
    @user  = create :user
    @order = create :order, user: @user
  end

  it 'has a valid factory' do
    expect(@order).to be_valid
  end

  describe 'cancelling' do
    it 'should cancel the order' do
      @order.cancel
      expect(@order.cancelled).to be true
    end

    it 'should not happen twice' do
      @order.cancel
      expect(@order.cancel).to be false
    end

    it 'should not work on old orders' do
      order = create :order, created_at: 3.days.ago
      expect(order.cancel).to be false
    end

    it 'should change the orders_count' do
      expect{@order.cancel}.to change{@user.reload.orders_count}.by(-1)
    end

    it 'should cancel the orderitems' do
      expect(@order.order_items.frst).to receive(:cancel)
      @order.cancel
    end
  end

  describe 'price' do
    it 'should be calculated from order_items' do
      @order = build :order, products_count: 0
      sum = (create_list :product, 1 + rand(10)).map do |p|
        create(:order_item, order: @order, product: p, count: 1 + rand(5)) do |oi|
          @order.order_items << oi
        end
      end.map{ |oi| oi.count * oi.product.price_cents }.sum
      expect(@order.price_cents).to eq(sum)
    end
  end
end
