module OrdersHelper

  def selected_user
    @selected_user ||= User.find_by(id: @user.id)
  end
end
