class WelcomeController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :token_sign_in

  def index
  end

  def token_sign_in
    if user_signed_in? || params[:token] != Rails.application.secrets.koelkast_token
      redirect_to root_path
      return
    end

    koelkast = User.koelkast
    sign_in_and_redirect koelkast
  end
end
