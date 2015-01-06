class UsersController < ApplicationController
  load_and_authorize_resource only: [:destroy]

  def show
    @user = User.find(params[:id])
    @orders = @user.orders.paginate(page: params[:page])
  end

  def index
    @users = User.members
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "Succesfully removed user"
    redirect_to users_path
  end

  def dagschotel
    user = User.find(params[:user_id])
    user.dagschotel = Product.find(params[:product_id])
    if user.save
      flash[:success] = "Succesfully removed user"
    else
      flash[:error] = "Error updating dagschotel"
    end
    redirect_to edit_user_registration_path(user)
  end
end
