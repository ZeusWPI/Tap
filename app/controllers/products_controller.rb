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
  end



  private

    def product_params
      params.require(:product).permit(:name, :sale_price, :purchase_price,
                                   :image_path)
    end
end
