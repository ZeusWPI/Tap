# frozen_string_literal: true

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
  let(:product) { create :product }
  let(:admin) { create :admin }

  before do
    sign_in admin
  end

  ##########
  #  POST  #
  ##########

  describe "POST create" do
    context "successful" do
      it "creates a barcode" do
        expect do
          post :create, params: { product_id: product, barcode: attributes_for(:barcode) }
        end.to change(Barcode, :count).by(1)
      end
    end

    context "failed" do
      it "does not create a barcode" do
        expect do
          post :create, params: { product_id: product, barcode: attributes_for(:invalid_barcode) }
        end.not_to change(Barcode, :count)
      end
    end
  end

  ###########
  #  INDEX  #
  ###########

  describe "GET index" do
    it "loads all the barcodes" do
      barcode = create :barcode
      get :index
      expect(assigns(:barcodes)).to eq([barcode])
    end
  end

  ##########
  #  SHOW  #
  ##########

  describe "GET show" do
    let(:barcode) { create :barcode }

    it "loads the correct barcode" do
      get :show, params: { id: barcode }
      expect(assigns(:barcode)).to eq(barcode)
    end

    it "allows friendly id" do
      get :show, params: { id: barcode.code }
      expect(assigns(:barcode)).to eq(barcode)
    end

    it "responds with this barcode" do
      get :show, params: { id: barcode }
      expect(response.body).to eq barcode.product.to_json
    end
  end
end
