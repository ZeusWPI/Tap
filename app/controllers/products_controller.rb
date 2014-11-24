class ProductsController < ApplicationController
  def new
    @product = Product.new
  end

  def create
    @product = Product.new(params_products)
    if @product.save
      redirect_to @product
    else
      render "new"
    end
  end

  def show
    @product = Product.find(params[:id])
  end

  def edit
  end

  def delete
  end

  private

    def params_products
      params.require(:product).permit(:name, :purchase_price, :sale_price,
                                      :img_path)
    end

end
