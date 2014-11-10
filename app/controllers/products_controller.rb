class ProductsController < ApplicationController
  def new
  	@product = Product.new
  end

  def show
  	@product = Product.find(params[:id])
  end

  def create
  	 @product = Product.new(product_params)    # Not the final implementation!
    if @product.save
      redirect_to @product
    else
      render 'new'
    end
  end

  def edit
  	@product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update_attributes(product_params)
      redirect_to @product
    else
      render 'edit'
    end
  end




  private

    def product_params
      params.require(:product).permit(:name, :sale_price, :purchase_price,
                                   :image_path)
    end
end
