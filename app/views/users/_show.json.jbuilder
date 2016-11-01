json.(user, :id, :name, :orders_count, :balance)
json.avatar image_path user.avatar.url
json.dagschotels do
  json.array! user.dagschotels.includes(:product) do |d|
    json.avatar image_path d.product.avatar.url
    json.order URI.join(Rails.application.config.root_url, orders_path(user_id: user.id, order: { product_id: d.product.id })).to_s
  end
end
