class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @orders = @user.orders.paginate(page: params[:page])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      redirect_to @user
    else
      render 'edit'
    end
  end

  def index
    @users = User.all
  end


  def destroy
    User.find(params[:id]).destroy
    redirect_to users_path
  end

  private

    def user_params
      params.require(:user).permit(:name, :last_name, :password,
                                   :password_confirmation, :nickname)
    end
end
