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
#  quickpay_hidden     :boolean
#  zauth_id            :string
#

#         quickpay_user GET      /users/:id/quickpay(.:format)            users#quickpay
#  edit_dagschotel_user GET      /users/:id/dagschotel/edit(.:format)     users#edit_dagschotel
#             edit_user GET      /users/:id/edit(.:format)                users#edit
#                  user GET      /users/:id(.:format)                     users#show
#                       PATCH    /users/:id(.:format)                     users#update
#                       PUT      /users/:id(.:format)                     users#update
#

describe UsersController do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  ##########
  #  SHOW  #
  ##########

  describe "GET show" do
    before do
      get :show, params: { id: user }
    end

    it "is successful" do
      expect(response).to have_http_status(:ok)
    end

    it "renders the user" do
      expect(response).to render_template(:show)
    end

    it "loads the correct user" do
      expect(assigns(:user)).to eq(user)
    end
  end

  ############
  #  UPDATE  #
  ############

  describe "PUT update" do
    it "loads the correct user" do
      put :update, params: { id: user, user: attributes_for(:user) }
      expect(assigns(:user)).to eq(user)
    end

    context "successful" do
      it "updates privacy" do
        new_private = !user.private
        put :update, params: { id: user, user: { private: new_private } }
        expect(user.reload.private).to be new_private
        expect(flash[:success]).to be_present
      end

      it "updates dagschotel" do
        product = create(:product)
        put :update, params: { id: user, user: { dagschotel_id: product.id } }
        expect(user.reload.dagschotel).to eq(product)
      end
    end

    context "danger zone" do
      it "errors for NOPs" do
        expect do
          put :update, params: { id: user, user: {} }
        end.to raise_error(ActionController::ParameterMissing)
      end
    end
  end

  #####################
  #  EDIT_DAGSCHOTEL  #
  #####################

  describe "GET edit_dagschotel" do
    it "is successful" do
      expect(response).to have_http_status(:ok)
    end

    it "renders the page" do
      get :edit_dagschotel, params: { id: user }
      expect(response).to render_template(:edit_dagschotel)
    end
  end

  ##############
  #  QUICKPAY  #
  ##############

  describe "GET quickpay" do
    describe "successful" do
      let(:dagschotel) { create(:product, stock: 20) }

      before do
        balance = 12_345
        stub_request(:get, /.*/).to_return(status: 200, body: JSON.dump({ balance: balance }))
        user.update(dagschotel: dagschotel)
      end

      it "is successful" do
        expect(response).to have_http_status(:ok)
      end

      it "makes an order" do
        expect do
          get :order_dagschotel, params: { id: user }
        end.to change { user.reload.orders_count }.by(1)
      end

      describe "order" do
        let(:order) do
          get :order_dagschotel, params: { id: user }
          user.orders.last
        end

        it "contains 1 orderitem" do
          expect(order.order_items.size).to eq 1
        end

        it "has an orderitem with count 1" do
          expect(order.order_items.first.count).to eq 1
        end

        it "contains an orderitem for @dagschotel" do
          expect(order.order_items.first.product).to eq dagschotel
        end
      end
    end

    # Some weird redirects happen here and I don't know what mock thing is
    # setting them up.

    # describe 'failed' do
    #   before :each do
    #     @dagschotel = create :product, stock: 0
    #     user.update_attribute(:dagschotel, @dagschotel)
    #   end

    #   it 'should fail' do
    #     xhr :get, :quickpay, id: user
    #     $stderr.puts response.body
    #     expect(response).to have_http_status(422)
    #   end

    #   it 'should not make an order' do
    #     expect{
    #       get :quickpay, id: user
    #     }.to_not change{ user.reload.orders_count }
    #   end
    # end
  end

  # quick order
  describe "POST quick_order" do
    let(:product) { create(:product, stock: 20) }

    before do
      # Mock the balance check (Tab API)
      balance = 12_345
      stub_request(:get, /.*/).to_return(status: 200, body: JSON.dump({ balance: balance }))
    end

    context "with a valid product_id" do
      it "creates a new order" do
        expect do
          post :quick_order, params: { id: user.id, product_id: product.id }
        end.to change { user.reload.orders_count }.by(1)
      end

      describe "the created order" do
        before do
          post :quick_order, params: { id: user.id, product_id: product.id }
        end

        let(:order) { user.orders.last }

        it "contains exactly 1 order item" do
          expect(order.order_items.size).to eq 1
        end

        it "contains the correct product" do
          expect(order.order_items.first.product).to eq product
        end
      end
    end

    context "with an invalid product_id" do
      it "does not create an order" do
        expect do
          post :quick_order, params: { id: user.id, product_id: 99_999 }
        end.not_to change(Order, :count)
      end
    end
  end
end
