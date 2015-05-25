class AppsController < ApplicationController
  before_action :authenticate_user!
  before_filter :find_app, only: [:edit, :show, :setup, :wait, :update, :destroy]

  def index
    @apps = current_user.apps.order(:name)
  end

  def new
    @app = App.new
  end

  def create
    @app = current_user.apps.new(filtered_app_params)
    if @app.save
      redirect_to @app
    else
      render action: "new"
    end
  end

  def show
    redirect_to app_statuses_path(@app)
  end

  def wait
    if @app.statuses.any?
      redirect_to @app
    else
      render
    end
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
    params.require(:app).permit(:name, :terms_of_service)
  end
end
