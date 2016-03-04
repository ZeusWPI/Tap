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
    authorize! :create, @user.orders.build
    order = @user.orders.build
    order.order_items.build(count: 1, product: @user.dagschotel)
    if order.save
      respond_to do |format|
        format.html { redirect_to(@user) }
        format.json { render json: { message: "Quick pay succeeded for #{@user.name}." }, status: :ok }
      end
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
