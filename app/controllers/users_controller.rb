class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @orders = @user.orders.paginate(page: params[:page])
  end

  def index
    @users = User.all
  end
end
