# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Orders" do
  let(:user) { create(:user) }

  before do
    stub_request(:get, /.*tab-test-url\.com.*/).to_return(status: 200, body: JSON.dump({ balance: 12_345 }))
    sign_in user
  end

  describe "NEW order" do
    it "initializes the barcode scan modal correctly" do
      visit new_user_order_path(user)

      find('a[href="#modalOrderScanner"]').click

      expect(page).to have_css(".scanner-canvas")
    end
  end
end
