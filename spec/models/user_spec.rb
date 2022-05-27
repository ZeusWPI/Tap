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
  before do
    @user = create :user
  end

  it "has a valid factory" do
    expect(@user).to be_valid
  end

  ############
  #  FIELDS  #
  ############

  describe "fields" do
    describe "avatar" do
      it "is present" do
        @user.avatar = nil
        expect(@user).not_to be_valid
      end
    end

    describe "orders_count" do
      it "automaticallies cache the number of orders" do
        balance = 5
        stub_request(:get, /.*/).to_return(status: 200, body: JSON.dump({ balance: balance }))
        expect { create :order, user: @user }.to change { @user.reload.orders_count }.by(1)
      end
    end

    describe "admin" do
      it "is false by default" do
        expect(@user.reload.admin).to be false
      end
    end

    describe "balance" do
      before :all do
        @api_url = "www.example.com/api.json"
      end

      it "is nil if offline" do
        stub_request(:get, /.*/).to_return(status: 404)
        expect(@user.balance).to be_nil
      end

      it "is updated when online" do
        balance = 5
        stub_request(:get, /.*/).to_return(status: 200, body: JSON.dump({ balance: balance }))
        expect(@user.balance).to eq balance
      end
    end
  end

  describe "omniauth" do
    it "is a new user" do
      name = "yet-another-test-user"
      omniauth = double(uid: name)
      expect(User.from_omniauth(omniauth).name).to eq name
    end

    it "is the logged in user" do
      second_user = create :user
      omniauth = double(uid: second_user.name)
      expect(User.from_omniauth(omniauth)).to eq second_user
    end
  end

  describe "static users" do
    describe "koelkast" do
      it "is false by default" do
        expect(@user.reload.koelkast).to be false
      end

      it "is true for koelkast" do
        expect(User.koelkast.koelkast).to be true
      end

      it "is not an admin" do
        expect(User.koelkast.admin).to be false
      end
    end

    describe "guest" do
      it "is not an admin" do
        expect(User.guest.admin).to be false
      end

      it "is public" do
        expect(User.guest.private).to be false
      end

      it "is a guest" do
        expect(User.guest.guest?).to be true
      end
    end
  end

  ############
  #  SCOPES  #
  ############

  describe "scopes" do
    it "members should return members" do
      create :koelkast
      user = create :user
      expect(User.members).to eq([@user, user])
    end

    it "publik should return publik members" do
      user = create :user
      create :user, private: true
      expect(User.publik).to eq([@user, user])
    end
  end

  describe "frecency" do
    before do
      balance = 5
      stub_request(:get, /.*/).to_return(status: 200, body: JSON.dump({ balance: balance }))
    end

    it "is recalculated on creating an order" do
      expect(@user.frecency).to eq 0
      create :order, user: @user
      expect(@user.frecency).not_to eq 0
    end

    # TODO: add a test to check if the frecency is correct. Note that
    #  frecency currently changes over time
  end
end
