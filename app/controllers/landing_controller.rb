# frozen_string_literal: true

class LandingController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :token_sign_in
  skip_before_action :authenticate_user!

  # Landing page
  # GET / (when logged out)
  def index; end

  def token_sign_in
    if user_signed_in? || params[:token] != Rails.application.secrets.koelkast_token
      redirect_to root_path
      return
    end

    koelkast = User.koelkast
    sign_in_and_redirect koelkast
  end
end
