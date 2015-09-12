require 'identicon'
require 'faker'

describe UsersController, type: :controller do
  before :each do
    @user = create :user
    sign_in @user
  end

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
    end
  end

  describe 'GET index' do
    before :each do
      get :index
    end

    it 'should load an array of all users' do
      expect(assigns(:users)).to eq([@user])
    end

    it 'should render the correct template' do
      expect(response).to render_template(:index)
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET edit_dagschotel' do
    it 'should render the page' do
      get :edit_dagschotel, id: @user
      expect(response).to render_template(:edit_dagschotel)
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET update_dagschotel' do
    it 'should update the dagschotel' do
      product = create :product
      get :update_dagschotel, id: @user, product_id: product
      expect(@user.reload.dagschotel).to eq(product)
    end
  end
end
