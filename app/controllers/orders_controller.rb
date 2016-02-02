class OrdersController < ApplicationController
  load_resource :user
  load_and_authorize_resource :order, through: :user, shallow: true, only: [:overview, :destroy]
  load_and_authorize_resource :order, through: :user, only: [:new, :create]

  def new
    @products = Product.all.for_sale.order(:name)
    @order.products << @products
  end

  def create
    @order.user = @user
    if @order.save
      flash[:success] = @order.flash_success
      redirect_to root_path
    else
      @products = Product.all.for_sale.order(:name)
      render 'new'
    end
  end

  def destroy
    @order.destroy
    flash[:success] = "Order has been removed."
    redirect_to root_path
  end

  def overview
    @users = User.members.publik.order(:name)
    @last = Order.order(:created_at).reverse_order.includes(:user).limit(10).map(&:user)
  end

  private

    def order_params
      params.require(:order).permit(order_items_attributes: [:count, :price, :product_id])
    end
end
