# == Schema Information
#
# Table name: barcodes
#
#  id         :integer          not null, primary key
#  product_id :integer
#  code       :string           default(""), not null
#  created_at :datetime
#  updated_at :datetime
#

class BarcodesController < ApplicationController
  load_and_authorize_resource :product, only: :create
  load_and_authorize_resource :barcode, through: :product, shallow: true
  respond_to :json

  def create
    @barcode.save
    redirect_to barcode_products_path, notice: "Barcode successfully linked!"
  end

  def index
    @barcodes = Barcode.all.order(:code)
    respond_with @barcodes
  end

  def show
    @barcode = Barcode.find_by(code: params[:id])
    render json: @barcode.try(:product)
  end

  def destroy
    @barcode.destroy
    redirect_to barcodes_path
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

  private

  def barcode_params
    params.require(:barcode).permit(:code)
  end
end
