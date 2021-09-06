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
#  quickpay_hidden     :boolean
#

class UsersController < ApplicationController
  load_and_authorize_resource

  # Do not set the user to the current logged in user when ordering a dagschotel.
  # This is to allow Koelkast to use this endpoint for other users.
  skip_before_action :set_user!, only: [:order_dagschotel]

  # User profile page
  # GET /users/{username}
  # GET / (when logged in, and not koelkast)
  def show
    respond_to do |format|
      format.json { render json: @user }
      format.html { }
    end
  end

  # Update a user
  # POST /users/{username}
  def update
    if user_params.empty?
      flash[:info] = "Nothing happened!"
      redirect_to @user
    else
      if @user.update_attributes(user_params)
        respond_to do |format|
          format.html do
            flash[:success] = "Successfully updated!"
            redirect_to @user
          end
          format.js { head :ok }
          format.json { render json: @user }
        end
      else
        respond_to do |format|
          format.html do
            flash[:error] = "Update failed!"
            @user.reload
            render "show"
          end
          format.js { head :bad_request }
          format.json { "Update failed!" }
        end
      end
    end
  end

  # Update dagschotel page
  # GET /users/{username}/dagschotel/edit
  def edit_dagschotel
    @dagschotel = @user.dagschotel

    @products = Product.for_sale
    @categories = Product.categories
  end

  # Order the user's dagschotel
  # POST /users/{username}/dagschotel/order
  # GET /users/{username}/quickpay (legacy endpoint, required not to break Tappb)
  def order_dagschotel
    authorize! :create, @user.orders.build
    order = @user.orders.build
    order.order_items.build(count: 1, product: @user.dagschotel)

    if order.save
      flash[:success] = "Your dagschotel has been ordered!"

      respond_to do |format|
        format.html { redirect_to(root_path) }
        format.json { render json: { message: "Quick pay succeeded for #{@user.name}." }, status: :ok }
      end
    else
      flash[:error] = order.valid? ? "Something went wrong! Please try again." : order.errors.full_messages.join(". ")
      redirect_to :back
    end
  end

  private

  def user_params
    params.fetch(:user, {}).permit(:avatar, :private, :dagschotel_id, :quickpay_hidden)
  end

  def reset_key
    @user.generate_key!
    redirect_to @user
  end
end
