class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  after_action :set_origin

  rescue_from CanCan::AccessDenied do |exception|
    render json: { error: message_for(exception) }, status: :forbidden
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
      "Betaal uw fucking schulden!"
    else
      exception.message
    end
  end

  def set_origin
    headers['Access-Control-Allow-Origin'] = '*'
  end
end
