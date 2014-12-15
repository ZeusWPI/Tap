module OrdersHelper
  include ActionView::Helpers::TextHelper

  def order_to_sentence(order)
    order.order_products.map {
      |op| pluralize(op.count, op.product.name)
    }.to_sentence
  end
end
