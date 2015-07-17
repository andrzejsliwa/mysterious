module AuthenticationHelper
  def login_as(email, role)
    @current_user = create(:user, email: email)
    @current_user.add_role(role)
    http_basic email, @current_user.password
  end
  attr_reader :current_user

  def http_basic(email, password)
    @env ||= {}
    @env['HTTP_AUTHORIZATION'] =
        ActionController::HttpAuthentication::Basic.encode_credentials(email, password)
  end

  def json_response
    JSON.parse(response.body)
  end
end