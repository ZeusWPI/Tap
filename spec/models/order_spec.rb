# frozen_string_literal: true

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
  let(:user) { create(:user) }
  let(:order) { create(:order, user: user) }

  before do
    stub_request(:get, /.*/).to_return(status: 200, body: JSON.dump({ balance: 20 }))
  end

  it "has a valid factory" do
    expect(order).to be_valid
  end

  ############
  #  FIELDS  #
  ############

  describe "fields" do
    describe "user" do
      it "is an association" do
        expect(described_class.reflect_on_association(:user).macro).to eq(:belongs_to)
      end

      it "is present" do
        order.user = nil
        expect(order).not_to be_valid
      end
    end

    describe "price_cents" do
      it "is calculated from order_items" do
        order = build(:order, products_count: 0)
        sum = create_list(:product, rand(1..10)).map do |p|
          build(:order_item, order: order, product: p, count: rand(1..5)) do |oi|
            order.order_items << oi
          end
        end
        sum = sum.map { |oi| oi.count * oi.product.price_cents }.sum
        order.save
        expect(order.price_cents).to eq(sum)
      end
    end

    describe "order_items" do
      it "is validated" do
        order.order_items.build(count: -5)
        expect(order).not_to be_valid
      end
    end
  end

  ###############
  #  CALLBACKS  #
  ###############

  describe "empty order_items" do
    it "is removed" do
      product = create(:product)
      order.order_items << create(:order_item, order: order, product: product, count: 0)
      order.save
      expect(order.order_items.where(product: product)).to be_empty
    end
  end

  #############
  #  HELPERS  #
  #############

  describe "deletable" do
    it "is true" do
      order.created_at = Rails.application.config.call_api_after.ago + 2.minutes
      expect(order.deletable?).to be true
    end

    it "is false" do
      order.created_at = Rails.application.config.call_api_after.ago - 2.minutes
      expect(order.deletable?).to be false
    end
  end

  it "sec_until_remove should return a number of seconds" do
    order.created_at = Rails.application.config.call_api_after.ago + 2.minutes
    expect((order.sec_until_remove - 120).abs).to be < 10
  end
end
