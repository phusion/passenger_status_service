class StatusesController < ApplicationController
  before_filter :authenticate_user!, except: [:create]
  before_filter :find_app
  before_filter :authenticate_api_token!, only: [:create]
  before_filter :find_status, only: [:edit, :show, :update, :destroy]

  def index
    @grouped_statuses = @app.statuses.group_by_hostname_and_time(@app.id)
  end

  def create
    status = @app.create_status_report_from_api_params(params)
    if status.new_record?
      render json: {
        status: "error",
        message: "Invalid parameters:\n" +
          status.errors.full_messages.join("\n")
      }
    else
      render json: { status: "ok" }
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
    @status = @app.statuses.find(params[:id])
    if @status.nil?
      render action: 'not_found', status: 404
    end
  end

  def authenticate_api_token!
    authenticated = authenticate_or_request_with_http_basic do |username, password|
      username == "api" && ActiveSupport::SecurityUtils.secure_compare(password, @app.api_token)
    end
  end
end
