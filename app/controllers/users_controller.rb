class UsersController < ApplicationController
  load_and_authorize_resource only: [:destroy]

  def show
    @user = User.find_by_id(params[:id]) || current_user
    @orders = Order.joins(:products).select(:count, "products.*", "orders.id").where(user: @user).group_by &:id
    @products = @user.products.select("products.*", "count(products.id) as count").group(:product_id)
    @categories = @user.products.select("products.category", "count(products.category) as count").group(:category)
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
      flash[:success] = "Succesfully updated dagschotel"
    else
      flash[:error] = "Error updating dagschotel"
    end
    redirect_to edit_user_registration_path(user)
  end
end
