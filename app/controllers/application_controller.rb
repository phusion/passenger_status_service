class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

private
  def after_sign_in_path_for(resource)
    apps_path
  end

  def allow_http_caching
    @public_caching = true
    headers["Cache-Control"] = "public"
    yield
    # Prevent turbocaching from caching our session cookie
    if headers["Set-Cookie"]
      headers["Set-Cookie"].clear
    end
  end
end
