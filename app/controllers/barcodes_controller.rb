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

  # Get a list of all barcodes
  # GET /barcodes
  def index
    @barcodes = Barcode.all.order(:code)
    respond_to do |format|
      format.json { render json: @barcodes }
      format.html {}
    end
  end

  # Create a new barcode page
  # GET /barcodes/new
  def new; end

  # Create a new barcode
  # POST /barcodes
  def create
    # If the barcode exists, redirect to the product page of that product
    if Barcode.where(code: @barcode.code).exists?
      flash[:info] = "Barcode already exists! This product is linked to the given barcode."
      redirect_to edit_product_path(Barcode.where(code: @barcode.code).take.product)
      return
    end

    # This is the first step of the create process
    # The barcode does not have a product yet, so redirect to the link page.
    unless @barcode.product

      # List with products and categories
      # If the user chooses to link the barcode to an existing product.
      @products = Product.all
      @categories = Product.categories

      # New product, if the user chooses for a new product
      @product = Product.new
      @product.barcodes.build(code: params[:barcode][:code])

      render :new_link
      return
    end

    # If the barcode was saved successfully
    # Otherwise, render the new page again, which will show the errors
    if @barcode.save
      flash[:success] = "Barcode successfully created and linked to #{@product.name}!"
      redirect_to barcodes_path
    else
      render :new
    end
  end

  # Get a barcode by id
  # GET /barcodes/{id}
  def show
    @barcode = Barcode.find_by(code: params[:id])
    render json: @barcode.try(:product)
  end

  # Delete a barcode
  # POST(method: DELETE) /barcodes/{id}
  def destroy
    if @barcode.destroy
      flash[:success] = "Barcode successfully deleted!"
      redirect_to barcodes_path
    else
      flash[:error] = "Barcode could not be deleted!"
      redirect_to barcodes_path
    end
  end

  private

  def barcode_params
    params.require(:barcode).permit(:code)
  end
end
