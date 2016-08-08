json.array! @orders do |order|
  json.(order, :created_at)
  json.product do 
    json.avatar URI.join(request.url, order.product.avatar.url).to_s
  end
end
