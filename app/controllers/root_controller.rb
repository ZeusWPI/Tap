class RootController < ApplicationController
  def root
    if !current_user
      redirect_to new_user_session_path
    elsif current_user.koelkast?
      redirect_to orders_path
    else
      redirect_to current_user
    end
  end
end
