class BarcodesController < ApplicationController
  load_resource :product
  load_and_authorize_resource :barcode, through: :product

  def create
    @barcode.save
    redirect_to barcode_products_path
  end

  private

  def barcode_params
    params.require(:barcode).permit(:code)
  end
end
