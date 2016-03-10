require 'cancan/matchers'

describe User do
  describe 'abilities' do
    subject(:ability){ Ability.new(user) }
    let(:user) { nil}

    # Admin
    describe 'as admin' do
      let(:user) { create :admin }

      it{ should be_able_to(:manage, Barcode) }
      it{ should be_able_to(:manage, Order) }
      it{ should be_able_to(:manage, Product) }
      it{ should be_able_to(:manage, Stock) }
      it{ should be_able_to(:manage, User) }
    end

    # Normal User
    describe 'as normal user' do
      let(:user) { create :user }

      # Barcodes
      it{ should be_able_to(:read, Barcode) }
      it{ should_not be_able_to(:create, Barcode) }
      it{ should_not be_able_to(:update, Barcode) }
      it{ should_not be_able_to(:destroy, Barcode) }

      # Orders
      describe 'balance' do
        describe 'offline' do
          before :each do
            stub_request(:get, /.*/)
              .to_return(status: 404)
          end
          it{ should be_able_to(:create, Order.new(user: user)) }
        end

        describe 'online' do
          describe 'greater than minimum' do
            before :each do
              stub_request(:get, /.*/)
                .to_return(body: { balance: 200 }.to_json)
            end
            it{ should be_able_to(:create, Order.new(user: user)) }
          end

          describe 'less than minimum' do
            before :each do
              stub_request(:get, /.*/)
                .to_return(body: { balance: -600 }.to_json)
            end
            it{ should_not be_able_to(:create, Order.new(user: user)) }
          end
        end
      end

      describe 'destroying orders' do
        describe 'when job not processed' do
          let(:order) { Order.new user: user,
                           created_at: (Rails.application.config.call_api_after - 1.minutes).ago }
          it{ should be_able_to(:destroy, order) }
        end

        describe 'when job processed' do
          let(:order) { Order.new user: user,
                           created_at: (Rails.application.config.call_api_after + 1.minutes).ago }
          it{ should_not be_able_to(:destroy, order) }
        end
      end

      it{ should_not be_able_to(:create, Order.new(user: create(:user))) }
      it{ should_not be_able_to(:update, Order) }

      it{ should be_able_to(:read, Product) }
      it{ should_not be_able_to(:destroy, Product) }
      it{ should_not be_able_to(:update, Product) }

      it{ should_not be_able_to(:create, Stock) }

      it{ should be_able_to(:manage, user) }
      it{ should_not be_able_to(:read, User) }
      it{ should_not be_able_to(:create, User) }
      it{ should_not be_able_to(:update, User) }
      it{ should_not be_able_to(:destroy, User) }
    end

    describe 'as koelkast' do
      let(:user) { User.koelkast }

      # Barcodes
      it{ should be_able_to(:read, Barcode) }
      it{ should_not be_able_to(:manage, Barcode) }

      # Products
      it{ should be_able_to(:read, Product) }
      it{ should_not be_able_to(:manage, Product) }

      # Stocks
      it{ should_not be_able_to(:manage, Stock) }

      # Users
      it{ should_not be_able_to(:manage, User.new) }

      # Orders
      describe 'balance user' do
        describe 'offline' do
          before :each do
            stub_request(:get, /.*/)
              .to_return(status: 404)
          end
          it{ should be_able_to(:create, Order.new(user: user)) }
        end

        describe 'online' do
          describe 'greater than minimum' do
            before :each do
              stub_request(:get, /.*/)
                .to_return(body: { balance: 200 }.to_json)
            end
            it{ should be_able_to(:create, Order.new(user: user)) }
          end

          describe 'less than minimum' do
            before :each do
              stub_request(:get, /.*/)
                .to_return(body: { balance: -600 }.to_json)
            end
            it{ should_not be_able_to(:create, Order.new(user: user)) }
          end
        end
      end

      describe 'private users' do
        let(:private_user) { create :user, :private }
        it{ should_not be_able_to(:create, Order.new(user: private_user)) }
      end
    end
  end
end
