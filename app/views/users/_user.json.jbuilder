json.(user, :id, :name)

json.avatar URI.join(request.url, user.avatar.url).to_s
if user.dagschotel
  json.dagschotel do
    json.url URI.join(request.url, user.dagschotel.avatar.url).to_s
    json.order user_orders_url(user, order: { product_id: user.dagschotel_id })
  end
end

products = @products[user.id] || []
products.delete(user.dagschotel)
products = products.take 3
json.most_ordered do
  json.array!(products) do |product|
    json.url URI.join(request.url, product.avatar.url).to_s
    json.order user_orders_url(user, order: { product_id: product.id })
  end
end
