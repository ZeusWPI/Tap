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
  before_action :init, only: :show
  load_and_authorize_resource find_by: :name
  respond_to :json, :html

  def show
    respond_with @user
  end

  def update
    @user.update user_params
    respond_with @user
  end

  def index
    @users = @users.members.publik.order(frecency: :desc)
    @products = Product.all.joins(:users).group(:product_id).select("products.*, users.id AS user_id, COUNT(*) AS count").order("user_id, count DESC").group_by(&:user_id)
    respond_with @users
  end

  private

    def user_params
      params.fetch(:user, {}).permit(:avatar, :private)
    end

    def init
      @user = current_user unless params[:id]
    end
end
