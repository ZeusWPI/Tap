class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token, if: :api_request?
  before_action :authenticate_user_from_token!
  before_action :authenticate_user!

  def api_request?
    (user_token.present?) && request.format.json?
  end

  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"

    respond_to do |format|
      format.json { render json: ["Diefstal is een misdrijf."], status: :forbidden }
      format.html { redirect_to root_path, flash: { error: message_for(exception) } }
    end
  end

  # Redirect path after signing in
  def after_sign_in_path_for(resource)
    root_path
  end

  # Redirect path after creating an account
  # Note: this is internal account creation for Tap, not a Zeus account creation
  def after_sign_up_path_for(resource)
    root_path
  end

  # Modify the browser's
  def set_theme_page
    @theme_variants = [
      { name: "Zeus Zoranje", hue: nil },
      { name: "Pink", hue: "310deg" },
      { name: "Purple", hue: "235deg" },
      { name: "Red", hue: "337deg" },
      { name: "Blue", hue: "210deg" },
      { name: "Green", hue: "120deg" },
    ]
    render "theme/index"
  end

  # Set the browser's theme
  # The theme will be stored in a cookie containing the name of the theme
  # POST /theme
  def set_theme
    cookies.permanent[:themeMode] = params[:theme][:mode] || "light"
    cookies.permanent[:themeVariantName] = params[:theme][:variantName]
    cookies.permanent[:themeVariantHue] = params[:theme][:variantHue]

    flash[:success] = "Theme has been set to #{params[:theme][:mode].capitalize} #{params[:theme][:variantName]}"
    redirect_back fallback_location: root_path
  end

  private

  def message_for(exception)
    if exception.subject.class == Order && [:new, :create].include?(exception.action)
      "Betaal uw fucking schulden! (Je kan niet negatief gaan)"
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

  def user_token
    @user_token ||= authenticate_with_http_token do |token, options|
      User.find_by userkey: token
    end
  end
end
