# == Schema Information
#
# Table name: orders
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  transaction_id :integer
#  product_id     :integer
#

class OrdersController < ApplicationController
  load_and_authorize_resource :user
  load_and_authorize_resource :order, through: :user, shallow: true

  respond_to :json, :html

  def new
    respond_with @order
  end

  def create
    respond_with @order do |format|
      if @order.save
        format.json { head :ok }
      else
        format.json { render json: @order.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @order.destroy
    respond_with @order
  end

  private

    def order_params
      params.require(:order).permit(:product_id, :user_id, :method)
    end
end
