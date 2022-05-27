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
#  avatar_file_name    :string
#  avatar_content_type :string
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  orders_count        :integer          default(0)
#  koelkast            :boolean          default(FALSE)
#  name                :string
#  private             :boolean          default(FALSE)
#  frecency            :integer          default(0), not null
#  quickpay_hidden     :boolean
#

require "webmock/rspec"

describe User do
  let(:user) { create :user }

  it "has a valid factory" do
    expect(user).to be_valid
  end

  ############
  #  FIELDS  #
  ############

  describe "fields" do
    describe "avatar" do
      it "is present" do
        user.avatar = nil
        expect(user).not_to be_valid
      end
    end

    describe "orders_count" do
      it "automaticallies cache the number of orders" do
        balance = 5
        stub_request(:get, /.*/).to_return(status: 200, body: JSON.dump({ balance: balance }))
        expect { create :order, user: user }.to change { user.reload.orders_count }.by(1)
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
    it "is a new user" do
      name = "yet-another-test-user"
      omniauth = double(uid: name)
      expect(described_class.from_omniauth(omniauth).name).to eq name
    end

    it "is the logged in user" do
      second_user = create :user
      omniauth = double(uid: second_user.name)
      expect(described_class.from_omniauth(omniauth)).to eq second_user
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
      create :koelkast
      local_user = create :user
      expect(described_class.members).to eq([local_user, user])
    end

    it "publik should return publik members" do
      local_user = create :user
      create :user, private: true
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
      create :order, user: user
      expect(user.frecency).not_to eq 0
    end

    # TODO: add a test to check if the frecency is correct. Note that
    #  frecency currently changes over time
  end
end
