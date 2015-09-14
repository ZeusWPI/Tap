class OrdersController < ApplicationController
  include ActionView::Helpers::NumberHelper
  include ApplicationHelper

  load_resource :user
  load_and_authorize_resource :order, through: :user, shallow: true, except: :destroy

  def new
    products = (@user.products.for_sale.select("products.*", "sum(order_items.count) as count").group(:product_id).order("count desc") | Product.for_sale)
    @order.g_order_items products
  end

  def create
    if @order.save
      flash[:success] = "#{@order.to_sentence} ordered. Enjoy it!"
      redirect_to root_path
    else
      render 'new'
    end
  end

  def destroy
    order = Order.unscoped.find(params[:id])
    authorize! :destroy, order
    if order.cancel
      flash[:success] = "Order has been removed."
    else
      flash[:error] = "Something went wrong. Perhaps this order was already cancelled, or it has been place too long ago."
    end
    redirect_to root_path
  end

  def overview
    @users = User.members.publik.order(:uid)
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
      params.require(:order).permit(order_items_attributes: [:count, :price, product_attributes: [:id]])
    end
end
