class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  # Only respond to JSON
  respond_to :json

  # Authenticate the API
  before_filter :restrict_access

  def ping
    render json: '{ "pong": true }'
  end

  private

  def restrict_access
    authenticate_or_request_with_http_token do |token, options|
      ApiKey.exists? access_token: token
    end
  end

end
