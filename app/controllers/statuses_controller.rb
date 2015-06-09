class StatusesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  before_filter :authenticate_user!, except: [:create]
  before_filter :authenticate_api_token_and_find_app!, only: [:create]
  before_filter :find_app, except: [:create]
  before_filter :find_status, only: [:edit, :show, :update, :destroy]

  def index
    authorize! :index, Status
    @grouped_statuses = @app.statuses.group_by_hostname_and_time(@app.id).to_a
  end

  def create
    status = @app.new_status_report_from_api_params(params)
    authorize! :create, status
    if status.valid?
      Status.transaction do
        @app.statuses.where(["updated_at < ?", RETENTION_TIME.ago]).delete_all
        status.save(validate: false)
      end
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
    authorize! :show, @status
  end

private
  def find_app
    begin
      @app = App.find(params[:app_id])
      authorize! :read, @app
    rescue ActiveRecord::RecordNotFound
      render template: 'apps/not_found', status: 404
    end
  end

  def find_status
    begin
      @status = @app.statuses.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render action: 'not_found', status: 404
    end
  end

  def authenticate_api_token_and_find_app!
    authenticated = authenticate_or_request_with_http_basic do |username, password|
      if username == "api"
        @app = App.find_by(api_token: password)
        if @app
          @current_user = @app.user
          authorize! :read, @app
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
