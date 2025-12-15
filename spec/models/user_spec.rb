# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  created_at          :datetime
#  updated_at          :datetime
#  remember_created_at :datetime
#  admin               :boolean          default(FALSE)
#  dagschotel_id       :integer
#  orders_count        :integer          default(0)
#  koelkast            :boolean          default(FALSE)
#  name                :string
#  private             :boolean          default(FALSE)
#  frecency            :integer          default(0), not null
#  quickpay_hidden     :boolean          default(FALSE)
#  userkey             :string
#  zauth_id            :integer
#

require "webmock/rspec"

describe User do
  let(:user) { create(:user) }

  it "has a valid factory" do
    expect(user).to be_valid
  end

  ############
  #  FIELDS  #
  ############

  describe "fields" do
    describe "orders_count" do
      it "automaticallies cache the number of orders" do
        balance = 5
        stub_request(:get, /.*/).to_return(status: 200, body: JSON.dump({ balance: balance }))
        expect { create(:order, user: user) }.to change { user.reload.orders_count }.by(1)
      end
    end

    describe "admin" do
      it "is false by default" do
        expect(user.reload.admin).to be false
      end
    end

    describe "balance" do
      it "is nil if offline" do
        stub_request(:get, /.*/).to_return(status: 404)
        expect(user.balance).to be_nil
      end

      it "is updated when online" do
        balance = 5
        stub_request(:get, /.*/).to_return(status: 200, body: JSON.dump({ balance: balance }))
        expect(user.balance).to eq balance
      end
    end
  end

  describe "omniauth" do
    describe "when the user is new" do
      let(:auth_hash) do
        OmniAuth::AuthHash.new(
          {
            uid: "yet-another-test-user",
            extra: {
              raw_info: { roles: [], id: 7 }
            }
          }
        )
      end

      it "creates a new user with the correct name" do
        user = described_class.from_omniauth(auth_hash)
        expect(user.name).to eq("yet-another-test-user")
        expect(user.zauth_id).to eq(7)
        expect(user.admin).to be(false)
      end
    end

    describe "when the user already exists" do
      let!(:existing_user) { create(:user) }
      let(:auth_hash) do
        OmniAuth::AuthHash.new(
          {
            uid: existing_user.name,
            extra: {
              raw_info: { roles: [], id: 7 }
            }
          }
          )
        end
        
      it "finds the existing user" do
        existing_user.zauth_id = 7
        existing_user.save
        
        user = described_class.from_omniauth(auth_hash)
        expect(user).to eq(existing_user)
        expect(user.admin).to be(false)
      end
    end

    describe "when the user already exists but without zauth id" do
      let!(:existing_user) { create(:user) }
      let(:auth_hash) do
        OmniAuth::AuthHash.new(
          {
            uid: existing_user.name,
            extra: {
              raw_info: { roles: [], id: 7 }
            }
          }
        )
      end

      it "finds the existing user" do
        user = described_class.from_omniauth(auth_hash)
        expect(user).to eq(existing_user)
        expect(user.admin).to be(false)
      end
    end

    describe "when the user exists but has changed their name" do
      let!(:existing_user) { create(:user) }
      let(:auth_hash) do
        OmniAuth::AuthHash.new(
          {
            uid: "new-username-from-zauth",
            extra: {
              raw_info: { roles: [], id: existing_user.zauth_id }
            }
          }
        )
      end

      it "updated the username" do
        existing_user.zauth_id = 7
        existing_user.save

        user = described_class.from_omniauth(auth_hash)
        expect(user.id).to eq(existing_user.id)
        expect(user.name).to eq("new-username-from-zauth")
      end
    end

    describe "when the user already exists and now has bestuur role" do
      let!(:existing_user) { create(:user) }
      let(:auth_hash) do
        OmniAuth::AuthHash.new(
          {
            uid: existing_user.name,
            extra: {
              raw_info: { roles: ["bestuur"], id: 7 }
            }
          }
          )
        end
        
        it "does not start with admin" do
          expect(user.admin).to be(false)
        end
        
        it "gets admin permissions" do
          existing_user.zauth_id = 7
          existing_user.save

          user = described_class.from_omniauth(auth_hash)
          expect(user).to eq(existing_user)
          expect(user.admin).to be(true)
      end
    end

    describe "when the user has bestuur role" do
      let(:auth_hash) do
        OmniAuth::AuthHash.new(
          {
            uid: "a-test-admin-user-bestuur",
            extra: {
              raw_info: { roles: ["bestuur"], id: 7 }
            }
          }
        )
      end

      it "creates a new user with admin" do
        user = described_class.from_omniauth(auth_hash)
        expect(user.name).to eq("a-test-admin-user-bestuur")
        expect(user.admin).to be(true)
      end
    end

    describe "when the user has tap_admin role" do
      let(:auth_hash) do
        OmniAuth::AuthHash.new(
          {
            uid: "a-test-admin-user-tap_admin",
            extra: {
              raw_info: { roles: ["tap_admin"], id: 7 }
            }
          }
        )
      end

      it "creates a new user with admin" do
        user = described_class.from_omniauth(auth_hash)
        expect(user.name).to eq("a-test-admin-user-tap_admin")
        expect(user.admin).to be(true)
      end
    end
  end

  describe "static users" do
    describe "koelkast" do
      it "is false by default" do
        expect(user.reload.koelkast).to be false
      end

      it "is true for koelkast" do
        expect(described_class.koelkast.koelkast).to be true
      end

      it "is not an admin" do
        expect(described_class.koelkast.admin).to be false
      end
    end

    describe "guest" do
      it "is not an admin" do
        expect(described_class.guest.admin).to be false
      end

      it "is public" do
        expect(described_class.guest.private).to be false
      end

      it "is a guest" do
        expect(described_class.guest.guest?).to be true
      end
    end
  end

  ############
  #  SCOPES  #
  ############

  describe "scopes" do
    it "members should return members" do
      create(:koelkast)
      local_user = create(:user)
      expect(described_class.members).to eq([local_user, user])
    end

    it "publik should return publik members" do
      local_user = create(:user)
      create(:user, private: true)
      expect(described_class.publik).to eq([local_user, user])
    end
  end

  describe "frecency" do
    before do
      balance = 5
      stub_request(:get, /.*/).to_return(status: 200, body: JSON.dump({ balance: balance }))
    end

    it "is recalculated on creating an order" do
      expect(user.frecency).to eq 0
      create(:order, user: user)
      expect(user.frecency).not_to eq 0
    end

    # TODO: add a test to check if the frecency is correct. Note that
    #  frecency currently changes over time
  end
end
