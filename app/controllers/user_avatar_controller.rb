class UserAvatarController < ApplicationController
  before_action :authenticate_session_user!

  def new
  end

  def create
    if @user.update_attributes(user_params)
      flash[:success] = "Your profile is complete. You are now logged in."
      reset_session
      sign_in_and_redirect @user
    else
      render 'new'
    end
  end

  def destroy
    reset_session
    redirect_to root_path
  end

  private

  def authenticate_session_user!
    redirect_to root_path unless session[:id]
    @user = User.find session[:id]
    unless @user
      reset_session
      redirect_to root_path
    end
  end

  def user_params
    params.require(:user).permit(:avatar)
  end
end
