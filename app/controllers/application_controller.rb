class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  check_authorization unless: :devise_controller?

private
  def after_sign_in_path_for(resource)
    apps_path
  end

  def allow_http_private_caching
    headers["Cache-Control"] = "private, max-age=2592000" # 1 month
    yield
  end
end
