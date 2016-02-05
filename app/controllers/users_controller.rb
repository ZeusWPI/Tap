class UsersController < ApplicationController
  load_and_authorize_resource
  before_action :init, only: :show

  def show
  end

  def update
    if user_params.empty?
      flash[:notice] = "Nothing happened."
      redirect_to @user
    elsif @user.update_attributes(user_params)
      flash[:success] = "Successfully updated!"
      redirect_to @user
    else
      flash[:error] = "Update failed!"
      @user.reload
      render 'show'
    end
  end

  def edit_dagschotel
    @dagschotel = @user.dagschotel

    @products = Product.for_sale
    @categories = Product.categories
  end

  def quickpay
    order = @user.orders.build
    order.order_items.build(count: 1, product: @user.dagschotel)
    if order.save
      render json: { message: "Quick pay succeeded for #{@user.name}." }, status: :ok
    else
      head :unprocessable_entity
    end
  end

  private

    def user_params
      params.fetch(:user, {}).permit(:avatar, :private, :dagschotel_id)
    end

    def init
      @user = User.find_by_id(params[:id]) || current_user
    end
end
