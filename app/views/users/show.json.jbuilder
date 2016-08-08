json.(@user, :id, :name, :orders_count, :balance)
json.avatar URI.join(request.url, @user.avatar.url).to_s
json.dagschotels do
  json.array! @user.dagschotels do |d|
    json.avatar = URI.join(request.url, d.product.avatar.url).to_s
    json.order orders_url(@user, user_id: @user.id, order: { product_id: d.product.id })
  end
end
