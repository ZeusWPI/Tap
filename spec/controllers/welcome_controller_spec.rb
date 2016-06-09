describe WelcomeController, type: :controller do
  include Devise::TestHelpers

  #########
  # INDEX #
  #########

  # describe 'GET index' do
    # it 'should be successful' do
      # get :index
      # expect(response).to have_http_status(200)
    # end
  # end

  # #################
  # # TOKEN_SIGN_IN #
  # #################

  # describe 'GET token_sign_in' do
    # describe 'correct token' do
      # it 'should sign in a user' do
        # get :token_sign_in, token: "testtoken"
        # expect(warden.authenticated?(:user)).to be true
      # end
    # end

    # describe 'failed with' do
      # it 'already signed in' do
        # get :token_sign_in, token: "wrongtoken"
        # expect(response).to have_http_status(:forbidden)
      # end

      # it 'wrong token' do
        # get :token_sign_in, token: "wrongtoken"
        # expect(response).to have_http_status(:forbidden)
      # end
    # end
  # end
end
