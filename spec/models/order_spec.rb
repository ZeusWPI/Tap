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
      expect(@user.reload.orders_count).to eq(1)
      @order.cancel
      expect(@user.reload.orders_count).to eq(0)
    end
  end
end
