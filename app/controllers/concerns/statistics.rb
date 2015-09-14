module Statistics
  extend ActiveSupport::Concern

  def products_group_by_category
    products
      .select("products.category", "sum(order_items.count) as count")
      .group(:category)
  end

  def all_orders page
    orders
      .order(:created_at)
      .reverse_order
      .paginate(page: page)
  end

  def products_group_by_id
    products
      .select("products.*", "sum(order_items.count) as count")
      .group(:product_id)
      .order("count")
      .reverse_order
  end
end
