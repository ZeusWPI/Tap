class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    head :forbidden
  end

  def after_sign_in_path_for(resource)
    root_path
  end
end
