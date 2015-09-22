# from_barcode_products POST     /products/barcode(.:format)                 products#from_barcode
#              products GET      /products(.:format)                         products#index
#                       POST     /products(.:format)                         products#create
#           new_product GET      /products/new(.:format)                     products#new
#          edit_product GET      /products/:id/edit(.:format)                products#edit
#               product PATCH    /products/:id(.:format)                     products#update
#                       PUT      /products/:id(.:format)                     products#update
#

describe ProductsController, type: :controller do
  before :each do
    @admin = create :admin
    sign_in @admin
  end

  #########
  #  NEW  #
  #########

  describe 'GET new' do
    it 'should render the form' do
      get :new
      expect(response).to render_template(:new)
      expect(response).to have_http_status(200)
    end

    it 'should initialize a new product' do
      get :new
      expect(assigns(:product).class).to eq(Product)
      expect(assigns(:product)).to_not be_persisted
    end
  end

  ##########
  #  POST  #
  ##########

  describe 'POST create' do
    context 'successfull' do
      it 'should create a product' do
        expect{
          post :create, product: attributes_for(:product)
        }.to change{ Product.count }.by(1)
      end

      it 'should redirect to index page' do
        post :create, product: attributes_for(:product)
        expect(response).to redirect_to action: :index
      end
    end

    context 'failed' do
      it 'should not create a product' do
        expect{
          post :create, product: attributes_for(:invalid_product)
        }.to_not change{Product.count}
      end

      it 'should render form' do
        post :create, product: attributes_for(:invalid_product)
        expect(response).to render_template(:new)
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
    end

    it 'should render the correct form' do
      get :edit, id: @product
      expect(response).to render_template(:edit)
      expect(response).to have_http_status(200)
    end

    it 'should load the correct product' do
      get :edit, id: @product
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
      put :edit, id: @product, product: attributes_for(:product)
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
        old_attributes = @product.attributes
        put :update, id: @product, product: attributes_for(:invalid_product)
        expect(@product.reload.attributes).to eq(old_attributes)
      end
    end
  end

  ##################
  #  FROM_BARCODE  #
  ##################

  describe 'POST from_barcode' do
    it 'should return a product when barcode in database' do
      product = create :product
      post :from_barcode, barcode: product.barcode
      expect(JSON.parse(response.body)["id"]).to eq(product.id)
    end
  end
end
