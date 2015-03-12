class UsersController < ApplicationController
  load_and_authorize_resource

  def show
    @user = User.find_by_id(params[:id]) || current_user
    @orders = @user.orders
      .active
      .order(:created_at)
      .reverse_order
      .paginate(page: params[:page])
    @products = @user.products
      .select("products.*", "sum(order_items.count) as count")
      .where("orders.cancelled = ?", false)
      .group(:product_id)
      .order("count")
      .reverse_order
    @categories = @user.products
      .select("products.category", "sum(order_items.count) as count")
      .where("orders.cancelled = ?", false)
      .group(:category)
  end

  def index
    @users = User.members
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:success] = "Succesfully removed user"
    redirect_to users_path
  end

  def dagschotel
    user = User.find(params[:user_id])

    if user.update_attributes(dagschotel: Product.find(params[:product_id]))
      flash[:success] = "Succesfully updated dagschotel"
    else
      flash[:error] = "Error updating dagschotel"
    end

    redirect_to edit_user_registration_path(user)
  end
end
