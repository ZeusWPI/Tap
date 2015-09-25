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
      format.html { redirect_to barcode_products_path }
    end
  end

  def from_barcode
    render json: Barcode.find_by_code(params.require(:barcode)).try(:product)
  end

  private

    def product_params
      params.require(:product).permit(:name, :price, :avatar, :category, :stock, :calories, :deleted, :barcode, barcodes_attributes: [:code])
    end
end
