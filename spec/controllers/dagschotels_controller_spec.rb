describe DagschotelsController, type: :controller do
  before :each do
    @user = create :admin
    sign_in @user
  end

  ########
  # EDIT #
  ########

  describe 'GET edit' do
    it 'should be successful' do
      get :edit, user_id: @user
      expect(response).to have_http_status(200)
    end
  end

  ###########
  # UPDATE  #
  ###########

  describe 'PUT update' do
    it 'should change the correct user' do
      put :update, user_id: @user, user: { dagschotel_id: create(:product) }
      expect(assigns(:user)).to eq @user
    end

    it 'should update the dagschotel' do
      product = create :product
      put :update, user_id: @user, user: { dagschotel_id: product }
      expect(@user.reload.dagschotel).to eq product
    end
  end

  ############
  # DESTROY  #
  ############

  describe 'DELETE destroy' do
    it 'should clear the dagschotel' do
      put :update, user_id: @user, user: { dagschotel_id: create(:product) }
      delete :destroy, user_id: @user
      expect(@user.reload.dagschotel).to be nil
    end
  end
end
