class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied, with: :render_forbidden
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  def render_forbidden
    render nothing: true, status: :forbidden
  end

  def render_not_found
    render nothing: true, status: :not_found
  end

  def render_validation(model)
    render json: { errors: model.errors },
        status: :unprocessable_entity
  end
end
