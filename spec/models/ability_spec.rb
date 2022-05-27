# frozen_string_literal: true

require "cancan/matchers"

describe Ability do
  describe "abilities" do
    subject(:ability) { described_class.new(user) }

    let(:user) { nil }

    # Admin
    describe "as admin" do
      let(:user) { create :admin }

      it { is_expected.to be_able_to(:manage, Barcode.new) }
      it { is_expected.to be_able_to(:manage, Product.new) }
      it { is_expected.to be_able_to(:manage, Stock.new) }
      it { is_expected.to be_able_to(:manage, User.new) }
    end

    # Normal User
    describe "as normal user" do
      let(:user) { create :user }

      # it{ should be_able_to(:create, Order.new(user: user)) }
      it {
        expect(ability).to be_able_to(:destroy,
                                      Order.new(user: user,
                                                created_at: (Rails.application.config.call_api_after - 1.minute).ago))
      }

      it { is_expected.not_to be_able_to(:destroy, Order.new(user: user, created_at: 10.minutes.ago)) }
      it { is_expected.not_to be_able_to(:create, Order.new) }
      it { is_expected.not_to be_able_to(:create, Order.new(user: create(:user))) }
      it { is_expected.not_to be_able_to(:update, Order.new) }

      it { is_expected.to be_able_to(:read, Product.new) }
      it { is_expected.not_to be_able_to(:destroy, Product.new) }
      it { is_expected.not_to be_able_to(:update, Product.new) }

      it { is_expected.not_to be_able_to(:create, Stock.new) }

      it { is_expected.to be_able_to(:manage, user) }
      it { is_expected.not_to be_able_to(:create, User.new) }
      it { is_expected.not_to be_able_to(:update, User.new) }
    end

    describe "as koelkast" do
      let(:user) { create :koelkast }

      it { is_expected.not_to be_able_to(:manage, Product.new) }
      # it{ should be_able_to(:manage, Order.new, user: create(:user)) }
      it { is_expected.not_to be_able_to(:create, build(:order, user: create(:user, private: true))) }
      it { is_expected.not_to be_able_to(:manage, Stock.new) }
      it { is_expected.not_to be_able_to(:manage, User.new) }
    end
  end
end
