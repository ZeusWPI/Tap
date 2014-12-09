class OrdersController < ApplicationController
  def overview
    @users_by_name = User.all.order(:name)
    @users_by_order = User.all
  end


  def new
    @user = User.find(params[:user_id])
    @order = @user.orders.build
    @products = Product.all
    @order_products = @order.order_products

    @products.each do |p|
      @order_products.build(product: p)
    end
  end


  def create
    @user = User.find(params[:user_id])
    @order = @user.orders.build(order_params)
    @products = Product.all
    @order_products = @order.order_products
    if @order.save
      @user.pay(@order.price)
      redirect_to root_path
    else
      render 'new'
    end
  end

  def index
    @user = User.find(params[:user_id])
    @orders = @user.orders
  end

  private

    def order_params
      params.require(:order).permit(order_products_attributes: [:product_id, :count])
    end
end
