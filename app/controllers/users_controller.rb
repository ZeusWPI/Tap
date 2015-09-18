class UsersController < ApplicationController
  load_and_authorize_resource
  before_action :init, only: :show

  def show
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Successfully updated!"
      redirect_to @user
    else
      @user.reload
      render 'edit'
    end
  end

  def edit_dagschotel
    @dagschotel = @user.dagschotel

    @products = Product.for_sale
    @categories = Product.categories
  end

  def update_dagschotel
    @user.dagschotel = Product.find(params[:product_id])
    @user.save

    flash[:success] = "Succesfully updated dagschotel"
    redirect_to @user
  end

  def quickpay
    order = @user.orders.build
    order.order_items.build(count: 1, product: @user.dagschotel)
    if order.save
      flash[:success] = "Quick pay succeeded. #{view_context.link_to("Undo", [@user, order], method: :delete)}."
    else
      flash[:error] = order.errors.full_messages.first
    end
    redirect_to root_path
  end

  private

    def user_params
      params.require(:user).permit(:avatar, :private)
    end

    def init
      @user = User.find_by_id(params[:id]) || current_user
    end
end
