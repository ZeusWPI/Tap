json.(order, :created_at)
json.product do
  json.avatar URI.join(Rails.application.config.root_url, order.product.avatar.url).to_s
end
