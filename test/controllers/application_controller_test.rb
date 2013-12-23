require "authenticator"
require "mocha/setup"

class ApplicationControllerTest < ActionController::TestCase

  def setup
    @token = ApiKey.create!.access_token
    @request.headers["Accept"] = "application/json"
    @request.headers["Content-Type"] = "application/json"
  end
  
  def test_unauthorized
    get :ping
    assert_response 401
  end

  def test_authorized
    @request.env["HTTP_AUTHORIZATION"] = "Token token=""#{@token}"""
    get :ping
    assert_response 200
  end

end
