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

  def edit_dagschotel
    @user = User.find(params[:user_id])
    @dagschotel = @user.dagschotel

    @products = Product.all
    @categories = Product.categories
  end

  def update_dagschotel
    @user = User.find(params[:user_id])
    @user.dagschotel = Product.find(params[:product_id])

    @products = Product.all
    @categories = Product.categories

    if @user.save
      flash[:success] = "Succesfully updated dagschotel"
      redirect_to @user
    else
      flash[:error] = "Error updating dagschotel"
      @dagschotel = @user.reload.dagschotel
      render 'edit_dagschotel'
    end

  end

  private

    def init
      @user = User.find(params[:user_id])
      redirect_to root_path, error: "You are not authorized to access this page." unless @user == current_user || current_user.admin?
    end
end
