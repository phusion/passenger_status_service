class StatusesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  before_filter :authenticate_user!, except: [:create]
  before_filter :authenticate_api_token_and_find_app!, only: [:create]
  before_filter :find_app, except: [:create]
  before_filter :find_status, only: [:edit, :show, :update, :destroy]

  def index
    authorize! :index, Status
    @hosts = @app.hosts.order('updated_at DESC,hostname').load
  end

  def create
    [:hostname, :content].each do |key|
      if params[key].blank?
        render json: {
          status: "error",
          message: "Key '#{key}' required"
        }
        return
      end
    end

    begin
      Status.transaction do
        host, host_found = @app.find_or_create_host_by_api_params(params)
        if host_found
          Rails.logger.info "Found host: #{params[:hostname]}"
        else
          Rails.logger.info "Registered new host: #{params[:hostname]}"
        end
        authorize! :create, host
        if host.errors.any?
          render json: {
            status: "error",
            message: "Invalid parameters for host object:\n" +
              host.errors.full_messages.join("\n")
          }
          return
        end

        status = host.new_status_report_from_api_params(params)
        authorize! :create, status
        if status.valid?
          status.save(validate: false)
          if host_found
            host.clean_old_status_reports
            host.updated_at = Time.now
            host.save!
          end
          render json: { status: "ok" }
        else
          render json: {
            status: "error",
            message: "Invalid parameters for status object:\n" +
              status.errors.full_messages.join("\n")
          }
        end
      end
    rescue ActiveRecord::RecordNotUnique
      Rails.logger.info "Duplicate record error. Retrying..."
      retry
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
