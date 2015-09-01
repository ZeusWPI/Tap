class ProductsController < ApplicationController
  load_and_authorize_resource

  respond_to :html, :js

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:success] = "Product created!"
      redirect_to products_path
    else
      render 'new'
    end
  end

  def index
    @products = Product.all
    @categories = Product.categories

    render 'products_list/listview' if current_user.admin?
  end

  def edit
    @product = Product.find(params[:id])
    respond_with @product
  end

  def update
    @product = Product.find(params[:id])
    @product.update_attributes product_params
    respond_with @product
  end

  private

    def product_params
      params.require(:product).permit(:name, :price, :avatar, :category, :stock, :calories, :deleted)
    end
end
