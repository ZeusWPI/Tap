class DagschotelsController < ApplicationController
  load_and_authorize_resource :user
  respond_to :json

  def edit
    respond_with @user
  end

  def update
    @user.update user_params
    respond_with @user
  end

  def destroy
    @user.update_attribute :dagschotel, nil
    respond_with @user
  end

  private

  def user_params
    params.fetch(:user, {}).permit(:dagschotel_id)
  end
end
