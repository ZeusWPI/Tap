# frozen_string_literal: true

class PublicController < ApplicationController
  include ApplicationHelper
  include OrderSessionHelper

  skip_before_action :authenticate_user_from_token!, only: :recent
  skip_before_action :authenticate_user!, only: :recent

  def recent
    orders = Order.recent
    mapped_orders = orders.joins(:order_items => :product).map do |order|
      order.order_items.map do |order_item|
        product = order_item.product
        {
          order_id: order.id,
          order_created_at: order.created_at,
          product_name: product.name,
          product_category: product.category
        }
      end
    end.flatten

    render json: { orders: mapped_orders }
  end
end
