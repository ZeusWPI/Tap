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
      @order_products.build(product: p)
    end
  end


  def create
    @user = User.find(params[:user_id])
    @order = @user.orders.build(order_params)
    @products = Product.all
    @products.each do |p|
      @order.order_products.build(product: p, count: order_products_params[p.id.to_s][:count])
    end

    if @order.save
      redirect_to root_path
    else
      @order_products = @order.order_products
      render 'new'
    end
  end

  private

    def order_params
      params.require(:order).permit()
    end

    def order_products_params
      params.require(:order).permit({:products => [:product_id, :count]})[:products]
    end
end
