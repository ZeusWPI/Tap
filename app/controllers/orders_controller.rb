# == Schema Information
#
# Table name: orders
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  price_cents    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  transaction_id :integer
#

class OrdersController < ApplicationController
  include ApplicationHelper

  load_and_authorize_resource :user, find_by: :name
  load_and_authorize_resource :order, through: :user, shallow: true, only: [:overview, :destroy]
  load_and_authorize_resource :order, through: :user, only: [:new, :create]

  # Create a new order page
  # GET /users/{username}/orders/new
  def new
    @products = Product.for_sale.order(:name).includes(:barcodes)
    @categories = Product.categories
    @order.products << @products
  end


  # Order products page
  # GET /users/{username}/orders/new/products
  def new_products
    @products = Product.for_sale.order(:name).includes(:barcodes)
    @categories = Product.categories
    render "new_products"
  end

  # Create a new order
  # POST /users/{username}/orders/new
  def create
    respond_to do |format|
      format.html do
        if @order.save
          flash[:success] = "#{@order.to_sentence} ordered."
          flash[:success] << " Please put #{euro_from_cents(@order.price_cents)} in our pot!" if @user.guest?
          flash[:success] << " Enjoy!"
          redirect_to root_path
        else
          flash[:error] = @order.valid? ? "Something went wrong! Please try again." : @order.errors.full_messages.join(". ")
          redirect_back fallback_location: root_path
        end
      end
      format.json do
        @order.save
        render json: @order
      end
    end
  end

  # Create an order
  # POST(method: DELETE) /users/{username}/orders/{id}
  def destroy
    @order.destroy
    flash[:success] = "Order has been removed."
    redirect_to root_path
  end

  # Koelkast overview
  # Only accessible by Koelkast
  # GET /overview
  def overview
    @users = User.members.publik.order(frecency: :desc)
    @last = Order.order(:created_at).reverse_order.includes(:user).limit(10).map(&:user)
  end

  private

  def order_params
    params.require(:order).permit(order_items_attributes: [:count, :price, :product_id])
  end
end
