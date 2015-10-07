class BarcodesController < ApplicationController
  load_and_authorize_resource :product, only: :create
  load_and_authorize_resource :barcode, through: :product, only: :create

  def create
    @barcode.save
    redirect_to barcode_products_path, notice: "Barcode successfully linked!"
  end

  def show
    @barcode = Barcode.find_by(code: params[:id])
    render json: @barcode.try(:product)
  end

  private

  def barcode_params
    params.require(:barcode).permit(:code)
  end
end
