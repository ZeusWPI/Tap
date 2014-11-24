class OrdersController < ApplicationController
  def new
    @users = User.all
  end

  def create_session
    user = User.find(params[:user_id])
    if user
      ordering(user)
      redirect_to order_path
    else
      redirect_to overview_path
    end
  end

  def order
    @order = current_ordering_user.orders.build
    @products = Product.all
  end


  def create
    @order = current_ordering_user.orders.build(order_params)
    if @order.save
      #flash[:success] = "order created!"
      end_order
      redirect_to overview_path
    else
      redirect_to overview_path
    end
  end

  def destroy
    end_order
    redirect_to overview_path
  end

  private

    def order_params
      params.require(:order).permit(:products)
    end
end
