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
    if @order.save
      order_products = order_products_params
      order_products.each do |k, v|
        @order.order_products.create(product: Product.find(k), count: v[:count]) if v[:count].to_i > 0
      end
      redirect_to root_path
    else
      @order_products = @order.order_products

      @products.each do |p|
        @order.order_products.build(product: p)
      end
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
