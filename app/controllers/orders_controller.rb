class OrdersController < ApplicationController
  include ActionView::Helpers::NumberHelper

  load_and_authorize_resource

  def new
    @user = User.find(params[:user_id])
    redirect_to root_path, flash: { error: "Koelkast can't order things." } if @user.koelkast?
    redirect_to root_path, flash: { error: "Please don't order stuff for other people" } unless current_user.koelkast? || current_user == @user

    @order = @user.orders.build
    # products = @user.products.select("products.*", "sum(order_items.count) as count").group(:product_id).order("count desc")
    # @order.g_order_items(products)
    @order.g_order_items(Product.all)
  end

  def create
    @user = User.find(params[:user_id])
    redirect_to root_path, flash: { error: "Koelkast can't order things." } if @user.koelkast?
    redirect_to root_path, flash: { error: "Please don't order stuff for other people" } unless current_user.koelkast? || current_user == @user

    @order = @user.orders.build(order_params)

    if @order.save
      flash[:success] = "#{@order.to_sentence} ordered. Enjoy it!"
      redirect_to root_path
    else
      @order.g_order_items(Product.all, order_params)
      @order.total_price = number_with_precision((@order.price / 100.0), precision: 2)
      render 'new'
    end
  end

  def destroy
    order = Order.find(params[:id])
    if order.created_at > 5.minutes.ago
      order.destroy
      flash[:success] = "Order has been removed."
    else
      flash[:error] = "This order has been placed too long ago, it can't be removed. Please contact a sysadmin."
    end
    redirect_to root_path
  end

  def overview
    @users = User.members.order(:name)
  end

  def quickpay
    user = User.find(params[:user_id])
    order = user.orders.build
    order.order_items << OrderItem.new(count: 1, product: user.dagschotel, order: order)
    if order.save
      flash[:success] = "Quick pay succeeded. #{view_context.link_to("Undo", [user, order], method: :delete)}."
    else
      flash[:error] = order.errors.full_messages.first
    end
    redirect_to root_path
  end

  private

    def order_params
      params.require(:order).permit(order_items_attributes: [:count, product_attributes: [:id]])
    end
end
