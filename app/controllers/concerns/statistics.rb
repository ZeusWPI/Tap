# frozen_string_literal: true

module Statistics
  extend ActiveSupport::Concern

  # Get all orders for the current user for a specific page.
  def all_orders(page)
    orders
      .order(:created_at)
      .reverse_order
      .paginate(page: page, per_page: 10)
  end

  # Get all products for all orders for the current user.
  # Group them by category.
  def products_group_by_category
    products
      .select("products.category", "sum(order_items.count) as count")
      .group(:category)
  end

  # Get all products for all orders for the current user.
  # Group them by id.
  # Sort them by count (times ordered).
  def products_group_by_id
    products
      .select("products.*", "sum(order_items.count) as count")
      .group("products.id")
      .order("count")
      .reverse_order
  end

  # Get the products ordered by most frequently ordered.
  # Only include the top x products.
  # Map by product name and order amount
  def most_frequently_ordered_products
    # Amount of products to include in the chart.
    # All other products will be grouped under "Others"
    products_amount = 10

    # Ordered products, grouped by product id.
    products_ordered = products_group_by_id

    # Select the top x products ordered by most frequently ordered.
    # Convert them to a hash with product name and order amount.
    products_ordered_top = products_ordered.limit(products_amount).to_h { |p| [p.name, p.count] }

    # Other products, not included in the top
    other_products = products_ordered.last([products_ordered.length - products_amount, 0].max)

    # Count all non included products
    other_products_count = other_products.map(&:count).sum

    products_ordered_top["Other"] = other_products_count if other_products_count.positive?

    products_ordered_top
  end
end
