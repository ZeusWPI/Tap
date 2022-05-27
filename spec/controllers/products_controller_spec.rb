# == Schema Information
#
# Table name: products
#
#  id                  :integer          not null, primary key
#  name                :string           not null
#  price_cents         :integer          default(0), not null
#  created_at          :datetime
#  updated_at          :datetime
#  avatar_file_name    :string
#  avatar_content_type :string
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  category            :integer          default(0)
#  stock               :integer          default(0), not null
#  calories            :integer
#  deleted             :boolean          default(FALSE)
#

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
          post :create, params: { product: attributes_for(:product) }
        }.to change{ Product.count }.by(1)
      end

      it 'should redirect to barcode page' do
        post :create, params: { product: attributes_for(:product) }
        expect(response).to redirect_to action: :index
      end
    end

    context 'failed' do
      it 'should not create a product' do
        expect{
          post :create, params: { product: attributes_for(:invalid_product) }
        }.to_not change{ Product.count}
      end

      it 'should render form' do
        post :create, params: { product: attributes_for(:invalid_product) }
        expect(response).to render_template("products/new")
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
      get :edit, params: { id: @product }
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
      put :update, params: { id: @product, product: attributes_for(:product) }
      expect(assigns :product).to eq(@product)
    end

    context 'successful' do
      it 'should update attributes' do
        put :update, params: { id: @product, product: { name: "new_product_name" } }
        expect(@product.reload.name).to eq("new_product_name")
      end
    end

    context 'failed' do
      it 'should not update attributes' do
        old_price = @product.price
        expect {
          put :update, params: { id: @product, product: attributes_for(:invalid_product) }
        }.to raise_error(ActiveRecord::RecordInvalid)
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
end
