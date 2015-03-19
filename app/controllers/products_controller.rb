class ProductsController < ApplicationController
  load_and_authorize_resource

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to products_path
    else
      render 'new'
    end
  end

  def index
    @products = Product.all
    @categories = Product.categories
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update_attributes(product_params)
      flash[:success] = "Succesfully updated product"
      redirect_to products_path
    else
      render 'edit'
    end
  end

  def destroy
    Product.find(params[:id]).destroy
    flash[:success] = "Succesfully removed product"
    redirect_to products_path
  end

  def stock
    @products = Product.all
  end

  def update_stock
    @products = Product.all
    @products.each do |product|
      stock_inc = params[:products][product.id.to_s][:stock_inc].to_i
      product.increment!(:stock, stock_inc) if stock_inc > 0
    end
    redirect_to products_path
  end

  private

    def product_params
      params.require(:product).permit(:name, :price, :avatar, :category, :stock)
    end
end
