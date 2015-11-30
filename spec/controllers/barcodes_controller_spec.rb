#      product_barcodes POST     /products/:product_id/barcodes(.:format) barcodes#create
#              barcodes GET      /barcodes(.:format)                      barcodes#index
#               barcode GET      /barcodes/:id(.:format)                  barcodes#show
#                       DELETE   /barcodes/:id(.:format)                  barcodes#destroy
#

describe BarcodesController, type: :controller do
  before :each do
    @admin = create :admin
    sign_in @admin
  end

  ##########
  #  POST  #
  ##########
  #
  describe 'POST create' do

  end

  ###########
  #  INDEX  #
  ###########

  describe 'GET index' do

  end

  ##########
  #  SHOW  #
  ##########

  describe 'GET show' do

  end
end
