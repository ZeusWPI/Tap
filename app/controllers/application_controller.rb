class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token, if: :api_request?
  before_filter :authenticate_user_from_token!
  before_filter :authenticate_user!
  before_filter :set_user!

  def api_request?
    (user_token.present?) && request.format.json?
  end

  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
    respond_to do |format|
      format.json { render json: [ "Diefstal is een misdrijf." ], status: :forbidden }
      format.html { redirect_to root_path, flash: { error: message_for(exception) } }
    end
  end

  def after_sign_in_path_for(resource)
    root_path
  end

  def after_sign_up_path_for(resource)
    root_path
  end

  private

  def message_for exception
    if exception.subject.class == Order && [:new, :create].include?(exception.action)
      "Betaal uw fucking schulden! (of zet meer geld op Tab)"
    else
      exception.message
    end
  end

  def authenticate_user_from_token!
    user = user_token

    if user
      # Notice we are passing store false, so the user is not
      # actually stored in the session and a token is needed
      # for every request. If you want the token to work as a
      # sign in token, you can simply remove store: false.
      sign_in user, store: false
    end
  end

  def set_user!
    @user = current_user
  end

  def user_token
    @user_token ||= authenticate_with_http_token do |token, options|
      User.find_by userkey: token
    end
  end

end
