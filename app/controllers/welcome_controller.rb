class WelcomeController < ApplicationController
  def index
    if user_signed_in?
      redirect_to apps_path
    else
      render
    end
  end
end
