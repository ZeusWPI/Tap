require "cancan/matchers"

describe User do
  describe "abilities" do
    subject(:ability){ Ability.new(user) }
    let(:user) { nil}

    describe "as admin" do
      let(:user) { create :admin }

      it{ should be_able_to(:manage, Product.new) }
      it{ should be_able_to(:manage, Order.new) }
      it{ should be_able_to(:manage, Stock.new) }
      it{ should be_able_to(:manage, User.new) }
    end

    describe "as normal user" do
      let(:user) { create :user }

      it{ should be_able_to(:read, Product.new) }
      it{ should_not be_able_to(:manage, Product.new) }

      it{ should be_able_to(:manage, Order.new(user: user)) }
      it{ should_not be_able_to(:manage, Order.new) }

      it{ should_not be_able_to(:manage, Stock.new) }

      it{ should be_able_to(:manage, user) }
      it{ should_not be_able_to(:manage, User.new) }
    end

    describe "as koelkast" do
      let(:user) { create :koelkast }

      it{ should_not be_able_to(:manage, Product.new) }
      it{ should be_able_to(:manage, Order.new) }
      it{ should_not be_able_to(:manage, Stock.new) }
      it{ should_not be_able_to(:manage, User.new) }
    end
  end
end
