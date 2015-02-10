class OrdersController < ApplicationController
  load_and_authorize_resource

  def new
    @user = User.find(params[:user_id])
    @order = @user.orders.build
    @products = Product.all
    @order_items = @order.order_items

    @products.each do |p|
      @order_items.build(product: p)
    end
  end

  def create
    @user = User.find(params[:user_id])
    @order = @user.orders.build(order_params)
    @products = Product.all
    @order_items = @order.order_items

    if @order.save
      flash[:success] = "#{@order.to_sentence} ordered. Enjoy it!"
      redirect_to root_path
    else
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
    redirect_to koelkast_root_path
  end

  def overview
    @users_by_name = User.members.order(:name)
    @users_by_order = User.members.order(:orders_count).reverse_order
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
      params.require(:order).permit(order_items_attributes: [:count, product_attributes: [:id, :price_cents, :stock]])
    end
end
