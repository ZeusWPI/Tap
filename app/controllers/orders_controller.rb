# frozen_string_literal: true

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
  include OrderSessionHelper

  load_and_authorize_resource :user, find_by: :name
  load_and_authorize_resource :order, through: :user, shallow: true, only: %i[overview destroy]
  load_and_authorize_resource :order, through: :user, only: %i[new create]

  # Create a new order page
  # GET /users/{username}/orders/new
  def new
    @products = Product.for_sale.order(:name)
    @categories = Product.categories

    # Get the order session for the user
    @order_session = pop_order_session(@user)

    # Build the order_items from the order session
    order_products = Product.find(@order_session[:product_ids])

    order_products.each do |order_product|
      # Get the count of the order item
      # This is the amount of times the product id is present inside the order session.
      count = @order_session[:product_ids].count(order_product.id)

      # Build the order_item
      @order.order_items.build(count: count, product: order_product)
    end

    @order.calculate_price
  end

  # Add or remove a product from/to the order
  # POST /users/{username}/orders/new
  def new_update
    action = params[:update_action]
    order_session = parse_order_session(params[:session])
    product_ids = order_session[:product_ids]

    # Add product to order form
    if action == "add"
      if params[:barcode]
        product = Barcode.find_by(code: params[:barcode]).try(:product)

        # If the product exists, add it to the order
        # Otherwise show an error message.
        if product
          # Add the product to the order session
          product_ids << product.id
        else
          flash[:error] = "No product with that barcode found!"
        end
      elsif params[:product_id]
        product = Product.find_by(id: params[:product_id])

        # If the product exists, add it to the order
        # Otherwise show an error message.
        if product
          # Add the product to the order session
          product_ids << product.id

        else
          flash[:error] = "That product does not exist!"
        end
      else
        flash[:error] = "Something went wrong!"
      end
    end

    # Remove product from the order form
    if action == "remove"
      if params[:product_id]
        product_ids.delete(JSON.parse(params[:product_id]))
      else
        flash[:error] = "Something went wrong!"
      end
    end

    # Push a new order session to the session store
    push_order_session(@user, product_ids)

    # Redirect back to the order page
    redirect_to new_user_order_path(@user)
  end

  # Order products page
  # GET /users/{username}/orders/new/products
  def new_products
    @products = Product.for_sale.order(:name)
    @categories = Product.categories
    @order_session = base64_decode_order_session(params[:session])
    render "new_products"
  end

  # Create a new order
  # POST /users/{username}/orders/new
  def create
    respond_to do |format|
      format.html do
        # Make sure the order is saved correctly
        if @order.save
          flash[:success] = "#{@order.to_sentence} ordered."
          flash[:success] << " Please put #{euro_from_cents(@order.price_cents)} in our pot!" if @user.guest?
          flash[:success] << " Enjoy!"

          # Redirect back to the root
          redirect_to root_path
        else
          flash[:error] =
            @order.valid? ? "Something went wrong! Please try again." : @order.errors.full_messages.join(". ")
          redirect_to new_user_order_path(@user)
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
    params.require(:order).permit(order_items_attributes: %i[count price product_id])
  end
end
