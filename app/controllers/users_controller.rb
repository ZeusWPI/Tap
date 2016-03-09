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

class UsersController < ApplicationController
  load_and_authorize_resource
  before_action :init, only: :show

  def show
  end

  def update
    if user_params.empty?
      flash[:notice] = "Nothing happened."
      redirect_to @user
    else
      if @user.update_attributes(user_params)
        respond_to do |format|
          format.html do
            flash[:success] = "Successfully updated!"
            redirect_to @user
          end
          format.js { head :ok  }
        end
      else
        respond_to do |format|
          format.html do
            flash[:error] = "Update failed!"
            @user.reload
            render 'show'
          end
          format.js { head :bad_request }
        end
      end
    end
  end

  def edit_dagschotel
    @dagschotel = @user.dagschotel

    @products = Product.for_sale
    @categories = Product.categories
  end

  def quickpay
    order = @user.orders.build
    order.order_items.build(count: 1, product: @user.dagschotel)
    if order.save
      render json: { message: "Quick pay succeeded for #{@user.name}." }, status: :ok
    else
      head :unprocessable_entity
    end
  end

  private

    def user_params
      params.fetch(:user, {}).permit(:avatar, :private, :dagschotel_id)
    end

    def init
      @user ||= current_user
    end
end
