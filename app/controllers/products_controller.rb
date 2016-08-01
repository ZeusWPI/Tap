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
  load_and_authorize_resource
  respond_to :json, :html

  def new
    respond_with @product
  end

  def create
    @product.save
    respond_with @product
  end

  def index
    @products   = Product.all
    @categories = Product.categories
    respond_with @products
  end

  def edit
    respond_with @product
  end

  def update
    @product.update product_params
    respond_with @product
  end

  private

    def product_params
      params.require(:product).permit(:name, :price, :avatar, :category,
                                      :stock, :calories, :deleted,
                                      barcodes_attributes: [:code])
    end
end
