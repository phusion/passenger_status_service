class StatusesController < ApplicationController
  before_action :authenticate_user!
  before_filter :find_app
  before_filter :find_status, only: [:edit, :show, :update, :destroy]

  def index
    @statuses = @app.statuses
  end

  def create
    status = Status.new_from_params(params)
    if !status.accept_tos?
      render json: {
        status: "error",
        message: "You must accept the terms of service"
      }
    elsif status.save
      render json: { status: "ok" }
    else
      render json: {
        status: "error",
        message: "Invalid parameters:\n" +
          status.errors.full_messages.join("\n")
      }
    end
  end

  def show
    authenticate_or_request_with_http_basic do |username, password|
      if username != "user"
        render_400
        return
      end

      @status = Status.find_by_params(params)
      if @status
        if @status.authenticate(password)
          render
        else
          render_401
        end
      else
        render_404
      end
    end
  end

private
  def find_app
    @app = current_user.apps.find(params[:app_id])
    if @app.nil?
      render action: 'apps/not_found', status: 404
    end
  end

  def find_status
    @status = @app.statuses.find(params[:app_id])
    if @status.nil?
      render action: 'not_found', status: 404
    end
  end
end
