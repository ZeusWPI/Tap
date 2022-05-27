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

#         quickpay_user GET      /users/:id/quickpay(.:format)            users#quickpay
#  edit_dagschotel_user GET      /users/:id/dagschotel/edit(.:format)     users#edit_dagschotel
#             edit_user GET      /users/:id/edit(.:format)                users#edit
#                  user GET      /users/:id(.:format)                     users#show
#                       PATCH    /users/:id(.:format)                     users#update
#                       PUT      /users/:id(.:format)                     users#update
#

describe UsersController, type: :controller do
  let(:user) { create :user }

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
      put :update, params: { id: user, user: attributes_for(:user).except(:avatar) }
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
        product = create :product
        put :update, params: { id: user, user: { dagschotel_id: product.id } }
        expect(user.reload.dagschotel).to eq(product)
      end

      it "accepts real images" do
        file = fixture_file_upload("real-image.png", "image/png")
        put :update, params: { id: user, user: { avatar: file } }
        expect(flash[:success]).to be_present
      end
    end

    context "danger zone" do
      it "errors for NOPs" do
        expect do
          put :update, params: { id: user, user: {} }
        end.to raise_error(ActionController::ParameterMissing)
      end

      it "does not accept unreal images" do
        file = fixture_file_upload("unreal-image.svg", "image/svg+xml")
        expect do
          put :update, params: { id: user, user: { avatar: file } }
        end.to raise_error(ActiveRecord::RecordInvalid)
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
      let(:dagschotel) { create :product, stock: 20 }

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
end
