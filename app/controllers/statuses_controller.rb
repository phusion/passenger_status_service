class StatusesController < ApplicationController
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
end
