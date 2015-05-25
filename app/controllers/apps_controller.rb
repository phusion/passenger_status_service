class AppsController < ApplicationController
  before_action :authenticate_user!
  before_filter :find_app, only: [:edit, :show, :update, :destroy]

  def index
    @apps = current_user.apps
  end

  def new
    @app = App.new
  end

  def create
    if @app = current_user.apps.create(filtered_app_params)
      redirect_to @app
    else
      render action: "new"
    end
  end

  def show
    redirect_to app_statuses_path(@app)
  end

  def update
    if @app.update_attributes(filtered_app_params)
      redirect_to @app
    else
      render action: "edit"
    end
  end

  def destroy
    @app.destroy!
    redirect_to apps_path
  end

private
  def find_app
    @app = current_user.apps.find(params[:id])
    if @app.nil?
      render action: 'not_found', status: 404
    end
  end

  def filtered_app_params
    params.require(:app).permit(:name, :accept_tos)
  end
end
