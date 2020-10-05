require 'cancan/matchers'

describe User do
  describe 'abilities' do
    subject(:ability){ Ability.new(user) }
    let(:user) { nil}

    # Admin
    describe 'as admin' do
      let(:user) { create :admin }

      it{ should be_able_to(:manage, Barcode.new) }
      it{ should be_able_to(:manage, Product.new) }
      it{ should be_able_to(:manage, Stock.new) }
      it{ should be_able_to(:manage, User.new) }
    end

    # Normal User
    describe 'as normal user' do
      let(:user) { create :user }

      # it{ should be_able_to(:create, Order.new(user: user)) }
      it{ should be_able_to(:destroy, Order.new(user: user, created_at: (Rails.application.config.call_api_after - 1.minutes).ago)) }
      it{ should_not be_able_to(:destroy, Order.new(user: user, created_at: 10.minutes.ago)) }
      it{ should_not be_able_to(:create, Order.new) }
      it{ should_not be_able_to(:create, Order.new(user: create(:user))) }
      it{ should_not be_able_to(:update, Order.new) }

      it{ should be_able_to(:read, Product.new) }
      it{ should_not be_able_to(:destroy, Product.new) }
      it{ should_not be_able_to(:update, Product.new) }

      it{ should_not be_able_to(:create, Stock.new) }

      it{ should be_able_to(:manage, user) }
      it{ should_not be_able_to(:create, User.new) }
      it{ should_not be_able_to(:update, User.new) }
    end

    describe 'as koelkast' do
      let(:user) { create :koelkast }

      it{ should_not be_able_to(:manage, Product.new) }
      # it{ should be_able_to(:manage, Order.new, user: create(:user)) }
      it{ should_not be_able_to(:create, build(:order, user: create(:user, private: true))) }
      it{ should_not be_able_to(:manage, Stock.new) }
      it{ should_not be_able_to(:manage, User.new) }
    end
  end
end
