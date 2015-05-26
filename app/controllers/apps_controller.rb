class AppsController < ApplicationController
  before_action :authenticate_user!
  before_filter :find_app, only: [:edit, :show, :setup, :wait, :update, :destroy]

  def index
    authorize! :index, App
    @apps = current_user.apps.order(:name)
  end

  def new
    @app = App.new
    authorize! :new, @app
  end

  def edit
    authorize! :edit, @app
  end

  def create
    @app = current_user.apps.new(filtered_app_params)
    authorize! :create, @app
    if @app.save
      redirect_to @app
    else
      render action: "new"
    end
  end

  def show
    authorize! :show, @app
    redirect_to app_statuses_path(@app)
  end

  def setup
    authorize! :read, @app
  end

  def wait
    authorize! :read, @app
    if @app.statuses.any?
      redirect_to @app
    else
      render
    end
  end

  def update
    authorize! :update, @app
    if @app.update_attributes(filtered_app_params)
      redirect_to @app
    else
      render action: "edit"
    end
  end

  def destroy
    authorize! :destroy, @app
    @app.destroy!
    redirect_to apps_path
  end

private
  def find_app
    begin
      @app = App.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render action: 'not_found', status: 404
    end
  end

  def filtered_app_params
    params.require(:app).permit(:name, :terms_of_service)
  end
end
