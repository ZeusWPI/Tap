# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  created_at          :datetime
#  updated_at          :datetime
#  remember_created_at :datetime
#  admin               :boolean          default(FALSE)
#  dagschotel_id       :integer
#  avatar_file_name    :string
#  avatar_content_type :string
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  orders_count        :integer          default(0)
#  koelkast            :boolean          default(FALSE)
#  name                :string
#  private             :boolean          default(FALSE)
#  frecency            :integer          default(0), not null
#

describe UsersController, type: :controller do
  before :each do
    @user = create :admin
    sign_in @user
  end

  ##########
  #  SHOW  #
  ##########

  describe 'GET show' do
    context 'with id' do
      it 'should be successful' do
        get :show, id: @user
        expect(response).to have_http_status(200)
      end

      it 'should load the correct user' do
        user = create :user
        get :show, id: user
        expect(assigns(:user)).to eq(user)
      end
    end

    context 'without id' do
      it 'should return the signed in user' do
        get :show
        expect(assigns(:user)).to eq(@user)
      end
    end
  end

  ############
  #  UPDATE  #
  ############

  describe 'PUT update' do
    it 'should load the correct user' do
      put :update, id: @user, user: attributes_for(:user)
      expect(assigns(:user)).to eq(@user)
    end

    context 'successful' do
      it 'should update privacy' do
        new_private = !(@user.private)
        put :update, id: @user, user: { private: new_private }
        expect(@user.reload.private).to be new_private
      end

      it 'should accept real images' do
        file = fixture_file_upload('files/real-image.png', 'image/png')
        put :update, id: @user, user: { avatar: file }
        expect(response).to have_http_status(204)
      end
    end

    context 'danger zone' do
      it 'should not accept unreal images' do
        file = fixture_file_upload('files/unreal-image.svg', 'image/svg+xml')
        expect{
          put :update, id: @user, user: { avatar: file }
        }.to_not change{ @user.avatar }
      end
    end
  end

  #########
  # INDEX #
  #########

  describe 'GET index' do
    it 'should be successful' do
      get :index
      expect(response).to have_http_status(200)
    end

    it 'should return an collection of users' do
      user = create :user
      get :index
      expect(assigns(:users)).to include user
    end
  end

  # #####################
  # #  EDIT_DAGSCHOTEL  #
  # #####################

  # describe 'GET edit_dagschotel' do
    # it 'should be successful' do
      # expect(response).to have_http_status(200)
    # end

    # it 'should render the page' do
      # get :edit_dagschotel, id: @user
      # expect(response).to render_template(:edit_dagschotel)
    # end
  # end

  # ##############
  # #  QUICKPAY  #
  # ##############

  # describe 'GET quickpay' do
    # describe 'successful' do
      # before :each do
        # @dagschotel = create :product, stock: 20
        # @user.update_attribute(:dagschotel, @dagschotel)
      # end

      # it 'should be successful' do
        # expect(response).to have_http_status(200)
      # end

      # it 'should make an order' do
        # expect{
          # get :quickpay, id: @user
        # }.to change{ @user.reload.orders_count }.by(1)
      # end

      # describe 'order' do
        # before :each do
          # get :quickpay, id: @user
          # @order = @user.orders.last
        # end

        # it 'should contain 1 orderitem' do
          # expect(@order.order_items.size).to eq 1
        # end

        # it 'should have an orderitem with count 1' do
          # expect(@order.order_items.first.count).to eq 1
        # end

        # it 'should contain an orderitem for @dagschotel' do
          # expect(@order.order_items.first.product).to eq @dagschotel
        # end
      # end
    # end

    # describe 'failed' do
      # before :each do
        # @dagschotel = create :product, stock: 0
        # @user.update_attribute(:dagschotel, @dagschotel)
      # end

      # it 'should fail' do
        # xhr :get, :quickpay, id: @user
        # expect(response).to have_http_status(422)
      # end

      # it 'should not make an order' do
        # expect{
          # get :quickpay, id: @user
        # }.to_not change{ @user.reload.orders_count }
      # end
    # end
  # end
end
