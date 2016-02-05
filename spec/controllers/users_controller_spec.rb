#         quickpay_user GET      /users/:id/quickpay(.:format)            users#quickpay
#  edit_dagschotel_user GET      /users/:id/dagschotel/edit(.:format)     users#edit_dagschotel
#             edit_user GET      /users/:id/edit(.:format)                users#edit
#                  user GET      /users/:id(.:format)                     users#show
#                       PATCH    /users/:id(.:format)                     users#update
#                       PUT      /users/:id(.:format)                     users#update
#

describe UsersController, type: :controller do
  before :each do
    @user = create :user
    sign_in @user
  end

  ##########
  #  SHOW  #
  ##########

  describe 'GET show' do
    before :each do
      get :show, id: @user
    end

    it 'should be successful' do
      expect(response).to have_http_status(200)
    end

    it 'should render the user' do
      expect(response).to render_template(:show)
    end

    it 'should load the correct user' do
      expect(assigns(:user)).to eq(@user)
    end
  end

  ############
  #  UPDATE  #
  ############

  describe 'PUT update' do
    it 'should load the correct user' do
      put :update, id: @user, user: attributes_for(:user)
      expect(assigns(:user)).to eq(@user)
    end

    context 'successful' do
      it 'should update attributes' do
        new_private = !(@user.private)
        put :update, id: @user, user: { private: new_private }
        expect(@user.reload.private).to be new_private
      end

      it 'should update dagschotel' do
        product = create :product
        put :update, id: @user, user: { dagschotel_id:  product.id }
        expect(@user.reload.dagschotel).to eq(product)
      end
    end
  end

  #####################
  #  EDIT_DAGSCHOTEL  #
  #####################

  describe 'GET edit_dagschotel' do
    it 'should be successful' do
      expect(response).to have_http_status(200)
    end

    it 'should render the page' do
      get :edit_dagschotel, id: @user
      expect(response).to render_template(:edit_dagschotel)
    end
  end

  ##############
  #  QUICKPAY  #
  ##############

  describe 'GET quickpay' do
    describe 'successful' do
      before :each do
        @dagschotel = create :product, stock: 20
        @user.update_attribute(:dagschotel, @dagschotel)
      end

      it 'should be successful' do
        expect(response).to have_http_status(200)
      end

      it 'should make an order' do
        expect{
          get :quickpay, id: @user
        }.to change{ @user.reload.orders_count }.by(1)
      end

      describe 'order' do
        before :each do
          get :quickpay, id: @user
          @order = @user.orders.last
        end

        it 'should contain 1 orderitem' do
          expect(@order.order_items.size).to eq 1
        end

        it 'should have an orderitem with count 1' do
          expect(@order.order_items.first.count).to eq 1
        end

        it 'should contain an orderitem for @dagschotel' do
          expect(@order.order_items.first.product).to eq @dagschotel
        end
      end
    end

    describe 'failed' do
      before :each do
        @dagschotel = create :product, stock: 0
        @user.update_attribute(:dagschotel, @dagschotel)
      end

      it 'should fail' do
        xhr :get, :quickpay, id: @user
        expect(response).to have_http_status(422)
      end

      it 'should not make an order' do
        expect{
          get :quickpay, id: @user
        }.to_not change{ @user.reload.orders_count }
      end
    end
  end
end
