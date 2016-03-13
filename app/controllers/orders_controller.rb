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

  def new
    respond_with @order
  end

  def create
    @order.save
    respond_with @order
  end

  def destroy
    @order.destroy
    respond_with @order
  end

  private

    def order_params
      params.require(:order).permit(:product_id)
    end
end
