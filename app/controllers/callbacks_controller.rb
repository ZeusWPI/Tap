class CallbacksController < Devise::OmniauthCallbacksController
  def zeuswpi
    @user = User.from_omniauth(request.env["omniauth.auth"])
    @user.save!(validate: false)
    if @user.valid?
      flash[:success] = "You are now logged in."
      sign_in_and_redirect @user
    else
      flash[:error] = "Please complete your profile first."
      session[:id] = @user.id
      redirect_to new_user_avatar_path
    end
  end

  def after_omniauth_failure_path_for(scope)
    root_path
  end
end
