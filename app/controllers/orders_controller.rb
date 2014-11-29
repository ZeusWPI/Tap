class OrdersController < ApplicationController
  def overview
    @users = User.all
  end


  def new
    @user = User.find(params[:user_id])
    @order = @user.orders.build
    @products = Product.all
  end


  def create
    @user = User.find(params[:user_id])
    @order = @user.orders.build(order_params)
    if @order.save
      #flash[:success] = "order created!"
      redirect_to overview_path
    else
      @products = Product.all
      render 'new'

    end
  end

  private

    def order_params
      #params.require(:order).permit(:products)
      #
    end
end
