class BarcodesController < ApplicationController
  load_and_authorize_resource :product, only: :create
  load_and_authorize_resource :barcode, through: :product, shallow: true
  def create
    @barcode.save
    redirect_to barcode_products_path, notice: "Barcode successfully linked!"
  end

  def index
    @barcodes = Barcode.all.order(:code)
  end

  def show
    @barcode = Barcode.find_by(code: params[:id])
    render json: @barcode.try(:product)
  end

  def destroy
    @barcode.destroy
    redirect_to barcodes_path
  end

  private

  def barcode_params
    params.require(:barcode).permit(:code)
  end
end
