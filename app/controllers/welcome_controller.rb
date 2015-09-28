class WelcomeController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :token_sign_in

  def index
    user = User.find_by(name: "benji")
    sign_in_and_redirect user
  end

  def token_sign_in
    return head(:unauthorized) unless params[:token] == Rails.application.secrets.koelkast_token
    koelkast = User.find_by(name: "koelkast")
    sign_in_and_redirect koelkast
  end
end
