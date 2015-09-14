# == Schema Information
#
# Table name: orders
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  price_cents    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  transaction_id :integer
#

describe Order do
  before :each do
    @user  = create :user
    @order = create :order, user: @user
  end

  it 'has a valid factory' do
    expect(@order).to be_valid
  end

  describe 'price' do
    it 'should be calculated from order_items' do
      @order = build :order, products_count: 0
      sum = (create_list :product, 1 + rand(10)).map do |p|
        create(:order_item, order: @order, product: p, count: 1 + rand(5)) do |oi|
          @order.order_items << oi
        end
      end.map{ |oi| oi.count * oi.product.price_cents }.sum
      @order.valid?
      expect(@order.price_cents).to eq(sum)
    end
  end
end
