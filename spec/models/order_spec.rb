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
    stub_request(:get, /.*/).to_return(status: 200, body: JSON.dump({ balance: 20 }))
    @user  = create :user
    @order = create :order, user: @user
  end

  it 'has a valid factory' do
    expect(@order).to be_valid
  end

  ############
  #  FIELDS  #
  ############

  describe 'fields' do
    describe 'user' do
      it 'should be an association' do
        expect(Order.reflect_on_association(:user).macro).to eq(:belongs_to)
      end

      it 'should be present' do
        @order.user = nil
        expect(@order).to_not be_valid
      end
    end

    describe 'price_cents' do
      it 'should be calculated from order_items' do
        @order = build :order, products_count: 0
        sum = (create_list :product, 1 + rand(10)).map do |p|
          create(:order_item, order: @order, product: p, count: 1 + rand(5)) do |oi|
            @order.order_items << oi
          end
        end.map{ |oi| oi.count * oi.product.price_cents }.sum
        @order.save
        expect(@order.price_cents).to eq(sum)
      end
    end

    describe 'order_items' do
      it 'should be validated' do
        @order.order_items.build(count: -5)
        expect(@order).to_not be_valid
      end
    end
  end

  ###############
  #  CALLBACKS  #
  ###############

  describe 'empty order_items' do
    it 'should be removed' do
      product = create :product
      @order.order_items << create(:order_item, order: @order, product: product, count: 0)
      @order.save
      expect(@order.order_items.where(product: product)).to be_empty
    end
  end

  #############
  #  HELPERS  #
  #############

  describe 'deletable' do
    it 'should be true' do
      @order.created_at = Rails.application.config.call_api_after.ago + 2.minutes
      expect(@order.deletable).to be true
    end

    it 'should be false' do
      @order.created_at = Rails.application.config.call_api_after.ago - 2.minutes
      expect(@order.deletable).to be false
    end
  end

  it 'sec_until_remove should return a number of seconds' do
    @order.created_at = Rails.application.config.call_api_after.ago + 2.minutes
    expect((@order.sec_until_remove - 120).abs).to be < 10
  end
end
