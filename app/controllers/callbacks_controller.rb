class CallbacksController < Devise::OmniauthCallbacksController
  def zeuswpi
    @user = User.from_omniauth(request.env["omniauth.auth"])
    @user.save
    sign_in_and_redirect @user
  end
end
