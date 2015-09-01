class UsersController < ApplicationController
  load_and_authorize_resource

  def show
    @user = User.find_by_id(params[:id]) || current_user
    @orders = @user.orders
      .order(:created_at)
      .reverse_order
      .paginate(page: params[:page])
    @products = @user.products
      .select("products.*", "sum(order_items.count) as count")
      .group(:product_id)
      .order("count")
      .reverse_order
    @categories = @user.products
      .select("products.category", "sum(order_items.count) as count")
      .group(:category)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Successfully updated!"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def index
    @users = User.members
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    flash[:success] = "Succesfully removed user"
    redirect_to users_path
  end

  def edit_dagschotel
    @user = User.find(params[:user_id])
    authorize! :update_dagschotel, @user
    @dagschotel = @user.dagschotel

    @products = Product.for_sale
    @categories = Product.categories
  end

  def update_dagschotel
    user = User.find(params[:user_id])
    authorize! :update_dagschotel, user

    user.dagschotel = Product.find(params[:product_id])
    user.save

    flash[:success] = "Succesfully updated dagschotel"
    redirect_to user
  end

  private

    def user_params
      params.require(:user).permit(:avatar, :private)
    end
end
