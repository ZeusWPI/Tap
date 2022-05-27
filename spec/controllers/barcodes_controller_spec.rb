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

#      product_barcodes POST     /products/:product_id/barcodes(.:format) barcodes#create
#              barcodes GET      /barcodes(.:format)                      barcodes#index
#               barcode GET      /barcodes/:id(.:format)                  barcodes#show
#                       DELETE   /barcodes/:id(.:format)                  barcodes#destroy
#

describe BarcodesController, type: :controller do
  before :each do
    @product = create :product
    @admin = create :admin
    sign_in @admin
  end

  ##########
  #  POST  #
  ##########

  describe 'POST create' do
    context 'successful' do
      it 'should create a barcode' do
        expect {
          post :create, params: { product_id: @product, barcode: attributes_for(:barcode) }
        }.to change{ Barcode.count }.by(1)
      end
    end

    context 'failed' do
      it 'should not create a barcode' do
        expect {
          post :create, params: { product_id: @product, barcode: attributes_for(:invalid_barcode) }
        }.to_not change{ Barcode.count }
      end
    end
  end

  ###########
  #  INDEX  #
  ###########

  describe 'GET index' do
    it 'should load all the barcodes' do
      barcode = create :barcode
      get :index
      expect(assigns(:barcodes)).to eq([barcode])
    end
  end

  ##########
  #  SHOW  #
  ##########

  describe 'GET show' do
    before :each do
      @barcode = create :barcode
    end

    it 'should load the correct barcode' do
      get :show, params: { id: @barcode }
      expect(assigns(:barcode)).to eq(@barcode)
    end

    it 'should allow friendly id' do
      get :show, params: { id: @barcode.code }
      expect(assigns(:barcode)).to eq(@barcode)
    end

    it 'should respond with this barcode' do
      get :show, params: { id: @barcode }
      expect(response.body).to eq @barcode.product.to_json
    end
  end
end
