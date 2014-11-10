class OrdersController < ApplicationController
	before_action :logged_in_user, only: [:create, :destroy]

  def new
    
  end

  def destroy
  end


  def show
  	@user = User.find(params[:id])
    @order = selected_user.orders.build
  end

  def create

		@order = current_user.orders.build(order_params)
    if @order.save
      #@flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @logs = []
      render 'static_pages/home'
    end
  end

  private

    def order_params
      params.require(:order).permit(:products)
    end
  

end
