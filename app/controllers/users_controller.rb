class UsersController < ApplicationController
  load_and_authorize_resource

  def show
    @user = User.find_by_id(params[:id]) || current_user
    @orders = @user.orders.includes(:products).paginate(page: params[:page])
    @products = @user.products.select("products.*", "sum(order_items.count) as count").group(:product_id)
    @categories = @user.products.select("products.category", "sum(order_items.count) as count").group(:category)
  end

  def index
    @users = User.members
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:success] = "Succesfully removed user"
    redirect_to action: :index
  end

  def dagschotel
    user = User.find(params[:user_id])
    user.dagschotel = Product.find(params[:product_id])
    if user.save
      flash[:success] = "Succesfully updated dagschotel"
    else
      flash[:error] = "Error updating dagschotel"
    end
    redirect_to edit_user_registration_path(user)
  end
end
