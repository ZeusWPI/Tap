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

describe OrdersController, type: :controller do
  let(:user) { create :user }

  before do
    stub_request(:get, /.*/).to_return(status: 200, body: JSON.dump({ balance: 12_345 }))
    sign_in user
  end

  ##########
  #  INDEX  #
  ##########

  describe "INDEX orders" do
    let!(:final_orders) do
      create_list :order, 2, user: user, created_at: Time.zone.now - Rails.application.config.call_api_after - 5.minutes
    end
    let!(:pending_orders) { create_list :order, 2, user: user, created_at: Time.zone.now }

    it "gets all orders for user without filter" do
      # Create some orders for another user
      other_user = create :user
      create_list :order, 2, user: other_user

      get :index, params: { user_id: user }, format: :json

      expect(response).to have_http_status(:ok)
      expected_result = JSON.parse(final_orders.concat(pending_orders).to_json(include: :products,
                                                                               methods: :deletable_until))
      actual_result = JSON.parse(response.body)
      expect(actual_result).to match_array(expected_result)
    end

    it "returns pending orders when requested" do
      get :index, params: { user_id: user, state: :pending }, format: :json
      pending_orders_json = JSON.parse(pending_orders.to_json(include: :products, methods: :deletable_until))
      expect(JSON.parse(response.body)).to match_array(pending_orders_json)
    end

    it "returns final orders when requested" do
      get :index, params: { user_id: user, state: :final }, format: :json
      final_orders_json = JSON.parse(final_orders.to_json(include: :products, methods: :deletable_until))
      expect(JSON.parse(response.body)).to match_array(final_orders_json)
    end
  end
end
