class AppsController < ApplicationController
  before_action :authenticate_user!

  def index
    @apps = current_user.apps
  end

  def new
    @app = App.new
  end
end
