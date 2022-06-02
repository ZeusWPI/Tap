# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id                  :integer          not null, primary key
#  name                :string           not null
#  price_cents         :integer          default(0), not null
#  created_at          :datetime
#  updated_at          :datetime
#  avatar_file_name    :string
#  avatar_content_type :string
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  category            :integer          default(0)
#  stock               :integer          default(0), not null
#  calories            :integer
#  deleted             :boolean          default(FALSE)
#

class ProductsController < ApplicationController
  load_and_authorize_resource except: :index

  # Get a list of all products
  # GET /products
  def index
    # If the user is not an admin, only show products that are not deleted
    @products = (current_user.admin? ? Product.all : Product.for_sale).order("name asc")
    @categories = Product.categories

    respond_to do |format|
      format.json { render json: @products }
      format.html {} # rubocop:disable Lint/EmptyBlock
    end
  end

  # Create a new product page
  # GET /products/new
  def new; end

  # Edit an existing product page
  # GET /products/edit/{id}
  def edit; end

  # Create a new product
  # POST /products
  def create
    # If the product was saved successfully
    # Otherwise, render the new page again, which will show the errors
    if @product.save
      flash[:success] = "Product has been created!"
      redirect_to products_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  # Update an existing product
  # POST /products/{id}
  def update
    # If the product was updated successfully
    # Otherwise, render the edit page again, which will show the errors
    if @product.update!(product_params)
      flash[:success] = "Product has been updated!"
      redirect_to products_path
    else
      render :edit
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :price, :avatar, :category, :stock, :calories, :deleted, :barcode,
                                    barcodes_attributes: %i[id code _destroy])
  end
end
