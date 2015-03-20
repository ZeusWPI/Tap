class SessionsController < Devise::SessionsController
  def new
    if session[:id]
      redirect_to new_user_avatar_path
      return
    end
    super
  end
end
