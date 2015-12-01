#      barcode_products GET      /products/barcode(.:format)              products#barcode
# load_barcode_products POST     /products/barcode(.:format)              products#load_barcode
#              products GET      /products(.:format)                      products#index
#                       POST     /products(.:format)                      products#create
#          edit_product GET      /products/:id/edit(.:format)             products#edit
#               product PATCH    /products/:id(.:format)                  products#update
#                       PUT      /products/:id(.:format)                  products#update
#

describe ProductsController, type: :controller do
  before :each do
    @admin = create :admin
    sign_in @admin
  end

  ############
  #  CREATE  #
  ############

  describe 'POST create' do
    context 'successful' do
      it 'should create a product' do
        expect{
          post :create, product: attributes_for(:product)
        }.to change{ Product.count }.by(1)
      end

      it 'should redirect to barcode page' do
        post :create, product: attributes_for(:product)
        expect(response).to redirect_to action: :barcode
      end
    end

    context 'failed' do
      it 'should not create a product' do
        expect{
          post :create, product: attributes_for(:invalid_product)
        }.to_not change{ Product.count}
      end

      it 'should render form' do
        post :create, product: attributes_for(:invalid_product)
        expect(response).to render_template(:link)
      end
    end
  end

  ###########
  #  INDEX  #
  ###########

  describe 'GET index' do
    it 'should load all the products' do
      product = create :product
      get :index
      expect(assigns :products).to eq([product])
    end
  end

  ##########
  #  EDIT  #
  ##########

  describe 'GET edit' do
    before :each do
      @product = create :product
      get :edit, id: @product
    end

    it 'should be successful' do
      expect(response).to have_http_status(200)
    end

    it 'should render the correct form' do
      expect(response).to render_template(:edit)
    end

    it 'should load the correct product' do
      expect(assigns :product).to eq(@product)
    end
  end

  ############
  #  UPDATE  #
  ############

  describe 'PUT update' do
    before :each do
      @product = create :product
    end

    it 'loads right product' do
      put :update, id: @product, product: attributes_for(:product)
      expect(assigns :product).to eq(@product)
    end

    context 'successful' do
      it 'should update attributes' do
        put :update, id: @product, product: { name: "new_product_name" }
        expect(@product.reload.name).to eq("new_product_name")
      end
    end

    context 'failed' do
      it 'should not update attributes' do
        old_price = @product.price
        put :update, id: @product, product: attributes_for(:invalid_product)
        expect(@product.reload.price).to eq(old_price)
      end
    end
  end

  #############
  #  BARCODE  #
  #############

  describe 'GET barcode' do
    it 'should be successful' do
      expect(response).to have_http_status(200)
    end
  end

  ##################
  #  LOAD_BARCODE  #
  ##################

  describe 'POST load_barcode' do
    describe 'new barcode' do
      before :each do
        @code = attributes_for(:barcode)[:code].to_s
        post :load_barcode, barcode: @code
      end

      it 'should be successful' do
        expect(response).to have_http_status(200)
      end

      it 'should be render the link partial' do
        expect(response).to render_template(:link)
      end

      it 'should allow building a new product' do
        expect(assigns(:product).id).to be nil
      end

      it 'should have a barcode built for the new product' do
        barcode = assigns(:product).barcodes.first
        expect(barcode.code).to eq @code
      end
    end

    describe 'existing barcode' do
      before :each do
        @barcode = create :barcode
        post :load_barcode, barcode: @barcode.code
      end

      it 'should be successful' do
        expect(response).to have_http_status(200)
      end

      it 'should be render the stock_entry partial' do
        expect(response).to render_template(:stock_entry)
      end

      it 'should have the correct product loaded' do
        expect(assigns :product).to eq @barcode.product
      end
    end
  end
end
