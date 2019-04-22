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
  load_and_authorize_resource :product, only: :create, except: :index
  load_and_authorize_resource :barcode, through: :product, shallow: true, except: :index

  def create
    @barcode.save
    redirect_to barcode_products_path, notice: "Barcode successfully linked!"
  end

  def index
    @barcodes = Barcode.all.order(:code)
    respond_to do |format|
      format.json {render json: @barcodes}
      format.html {}
    end
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
