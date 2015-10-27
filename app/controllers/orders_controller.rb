class OrdersController < ApplicationController
  load_resource :user
  load_and_authorize_resource :order, through: :user, shallow: true

  def new
    @products = Product.all.for_sale.order(:name)
    @order.products << @products
  end

  def create
    if @order.save
      flash[:success] = "#{@order.to_sentence} ordered. Enjoy it!"
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
  end

  private

    def order_params
      params.require(:order).permit(order_items_attributes: [:count, :price, product_attributes: [:id]])
    end
end
