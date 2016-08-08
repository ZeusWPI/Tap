json.(@user, :id, :name, :orders_count, :balance)
json.avatar URI.join(request.url, @user.avatar.url).to_s
