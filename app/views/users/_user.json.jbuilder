json.(user, :id, :name)

json.avatar URI.join(request.url, user.avatar.url).to_s
products = @products[user.id] || []
products = products.take 4
json.quick_order do
  json.array!(products) do |product|
    json.avatar URI.join(request.url, product.avatar.url).to_s
    json.order user_orders_url(user, order: { product_id: product.id })
    json.(product, :id)
  end
end
