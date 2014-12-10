class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @orders = @user.orders.paginate(page: params[:page])
  end

  def index
    @users = User.all
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "Succesfully removed user"
    redirect_to users_path
  end

  def dagschotel
    user = User.find(params[:user_id])
    user.dagschotel = Product.find(params[:product_id])
    user.save
    redirect_to edit_user_registration_path(user)
  end
end
