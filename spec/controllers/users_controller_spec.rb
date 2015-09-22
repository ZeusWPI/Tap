#         quickpay_user GET      /users/:id/quickpay(.:format)               users#quickpay
#  edit_dagschotel_user GET      /users/:id/dagschotel/edit(.:format)        users#edit_dagschotel
#             edit_user GET      /users/:id/edit(.:format)                   users#edit
#                  user GET      /users/:id(.:format)                        users#show
#                       PATCH    /users/:id(.:format)                        users#update
#                       PUT      /users/:id(.:format)                        users#update
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
      expect(response).to render_template(:show)
      expect(response).to have_http_status(200)
    end

    it 'should load the correct user' do
      expect(assigns(:user)).to eq(@user)
    end
  end

  ##########
  #  EDIT  #
  ##########

  describe 'GET edit' do
    before :each do
      get :edit, id: @user
    end

    it 'should render the form' do
      expect(response).to render_template(:edit)
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
    it 'should render the page' do
      get :edit_dagschotel, id: @user
      expect(response).to render_template(:edit_dagschotel)
      expect(response).to have_http_status(200)
    end
  end
end
