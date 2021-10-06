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
    @products = Product.for_sale.order(:name)
    @categories = Product.categories

    # When creating an order the session is used to store the products of the order.
    # The products for a specific order are stored as a list of product ids.
    # Ids can be used multiple times when ordering multiples of the same item.
    session[:order] ||= []

    # Build the order_items from the session
    order_products = Product.find(session[:order])

    for order_product in order_products

      # Get the count of the order item
      # This is the amount of times the product id is present inside the order session.
      count = session[:order].count(order_product.id)

      # Build the order_item
      @order.order_items.build(count: count, product: order_product)
    end

    @order.calculate_price
  end

  # Add a product to the order
  # POST /users/{username}/orders/new_add
  def new_add
    if params[:barcode]
      product = Barcode.find_by(code: params[:barcode]).try(:product)

      # If the product exists, add it to the order
      # Otherwise show an error message.
      if product
        # Add the product to the order session
        session[:order] << product.id
      else
        flash[:error] = "No product with that barcode found!"
      end
    elsif params[:product_id]
      product = Product.find_by(id: params[:product_id])

      # If the product exists, add it to the order
      # Otherwise show an error message.
      if product
        # Add the product to the order session
        session[:order] << product.id
      else
        flash[:error] = "That product does not exist!"
      end
    else
      flash[:error] = "Something went wrong!"
    end

    # Redirect back
    redirect_back fallback_location: new_user_order_path(current_user)
  end

  # Remove a product from the order
  # POST /users/{username}/orders/new_remove
  def new_remove
    if params[:product_id]
      session[:order].delete(params[:product_id])
    else
      flash[:error] = "Something went wrong!"
    end
  end

  # Order products page
  # GET /users/{username}/orders/new/products
  def new_products
    @products = Product.for_sale.order(:name)
    @categories = Product.categories
    render "new_products"
  end

  # Create a new order
  # POST /users/{username}/orders/new
  def create
    respond_to do |format|
      format.html do
        # Make sure the user can pay the order
        if @user.try(:balance).try(:<, @order.price_cents)
          flash[:error] = "You do not have enough money to order this!"
          redirect_back fallback_location: root_path

        # Make sure the order is saved correctly
        elsif @order.save
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
