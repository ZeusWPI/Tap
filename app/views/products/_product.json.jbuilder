json.(product, :id, :name, :price, :calories, :category, :stock)
json.avatar URI.join(request.url, product.avatar.url).to_s
