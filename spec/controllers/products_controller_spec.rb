describe ProductsController, type: :controller do
  before :each do
    @admin = create :admin
    sign_in @admin
  end

  describe 'GET new' do
    it 'should render the form' do
      get :new
      expect(response).to render_template(:new)
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST create' do
    context 'successfull' do
      it 'should create a product' do
        expect{
          post :create, product: attributes_for(:product)
        }.to change{Product.count}.by(1)
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

  describe 'GET index' do
    it 'should load all the products' do
      product = create :product
      get :index
      expect(assigns :products).to eq([product])
    end
  end

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
        attributes = attributes_for(:product)
        attributes.merge(price: (attributes[:price_cents] / 100))
        attributes.delete(:price_cents)
        put :update, id: @product, product: attributes
        new_attributes = @product.reload.attributes.symbolize_keys.slice(*attributes.keys)
        expect(new_attributes).to eq(attributes.except(:avatar))
      end
    end

    context 'failed' do
      it 'should not update attributes' do
        old_attributes = @product.reload.attributes
        put :update, id: @product, product: attributes_for(:invalid_product)
        expect(@product.reload.attributes).to eq(old_attributes)
      end
    end
  end
end
