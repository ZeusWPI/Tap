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

  respond_to :html, :js

  def create
    if @product.save
      flash[:success] = "Product created!"
      redirect_to barcode_products_path
    else
      render 'link'
    end
  end

  def barcode
  end

  def load_barcode
    @product = Barcode.find_by(code: params[:barcode]).try(:product)
    if @product
      render 'products/stock_entry'
    else
      @product = Product.new
      @product.barcodes.build(code: params[:barcode])
      render 'products/link'
    end
  end

  def index
    @products = Product.all
    @categories = Product.categories

    render 'products_list/listview' if current_user.admin?
  end

  def edit
    respond_with @product
  end

  def update
    @product.update_attributes product_params
    respond_to do |format|
      format.js   { respond_with @product }
      format.html { redirect_to barcode_products_path, notice: "Stock has been updated!" }
    end
  end

  private

    def product_params
      params.require(:product).permit(:name, :price, :avatar, :category, :stock, :calories, :deleted, :barcode, barcodes_attributes: [:code])
    end
end
