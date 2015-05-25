class StatusesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  before_filter :authenticate_user!, except: [:create]
  before_filter :authenticate_api_token_and_find_app!, only: [:create]
  before_filter :find_app, except: [:create]
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

  def authenticate_api_token_and_find_app!
    authenticated = authenticate_or_request_with_http_basic do |username, password|
      if username == "api"
        @app = App.find_by(api_token: password)
        if @app
          true
        else
          false
        end
      else
        false
      end
    end
  end
end
