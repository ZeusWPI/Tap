class OrdersController < ApplicationController
  def overview
    @users = User.all
  end


  def new
    @user = User.find(params[:user_id])
    @order = @user.orders.build
    @products = Product.all
    @order_products = @order.order_products

    @products.each do |p|
      @order.order_products.build(product: p)
    end
  end


  def create
    @user = User.find(params[:user_id])
    @order = @user.orders.build
    @products = Product.all
    @order_products = @order.order_products

    @products.each do |p|
      @order.order_products.build(product: p)
    end
    render 'new'
  end

  private

    def order_params
      params.require(:order).permit(:products)
    end
end
