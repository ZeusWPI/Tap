# == Schema Information
#
# Table name: orders
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  transaction_id :integer
#  product_id     :integer
#

describe Order do
  before :all do
    @user  = create :user
    @order = create :order, user: @user
  end

  before :each do
    @order.reload
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

    describe 'product' do
      it 'should be an association' do
        expect(Order.reflect_on_association(:product).macro).to eq(:belongs_to)
      end

      it 'should be present' do
        @order.product = nil
        expect(@order).to_not be_valid
      end
    end
  end

  ###############
  #  CALLBACKS  #
  ###############

  describe 'update_user_frecency' do
    it 'should update on create' do
      expect{ create(:order, user: @user) }.to change{ @user.frecency }
    end

    it 'should update on destroy' do
      order = create :order, user: @user
      expect{ order.destroy }.to change{ @user.frecency }
    end
  end

  # #############
  # #  HELPERS  #
  # #############

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
end
