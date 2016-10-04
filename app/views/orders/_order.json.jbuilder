json.(order, :created_at)
puts "OOOORDER"
p order
p order.product.avatar.url
p asset_url(order.product.avatar.url)
p image_url(order.product.avatar.url)
puts request.url
puts :root_url
json.product do 
  json.avatar URI.join(request.url, order.product.avatar.url).to_s
end
