class UserAvatarController < ApplicationController
  before_action :authenticate_session_user!

  def new
  end

  def create
    if @user.update_attributes(user_params)
      flash[:success] = "Your profile is complete. You are now logged in."
      sign_in_and_redirect @user
    else
      render 'new'
    end
  end

  private

  def authenticate_session_user!
    redirect_to root_path unless session[:id]
    @user = User.find session[:id]
  end

  def user_params
    params.require(:user).permit(:avatar)
  end
end
