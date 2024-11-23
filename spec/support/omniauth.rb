module OAuthHelper
  def mock_oauth2_flow
    access_token = mock_access_token
    auth_code = mock_auth_code(access_token)
    mock_oauth2_client(auth_code)
  end

  private

  def mock_access_token
    # アクセストークンのモックを作成
    instance_double(OAuth2::AccessToken).tap do |access_token|
      user_response = Struct.new(:body).new({
        userId: '12345',
        displayName: 'test_user'
      }.to_json)

      allow(access_token).to receive(:get).and_return(user_response)
    end
  end

  def mock_auth_code(access_token)
    # AuthCodeストラテジーのモックを作成
    instance_double(OAuth2::Strategy::AuthCode).tap do |auth_code|
      allow(auth_code).to receive_messages(
        get_token: access_token,
        authorize_url: 'http://example.com/auth'
      )
    end
  end

  def mock_oauth2_client(auth_code)
    # OAuth2クライアントのモックを作成
    instance_double(OAuth2::Client).tap do |oauth2_client|
      allow(oauth2_client).to receive(:auth_code).and_return(auth_code)
      allow(OAuth2::Client).to receive(:new).and_return(oauth2_client)
    end
  end
end

RSpec.configure do |config|
  config.include OAuthHelper, type: :request
  config.include OAuthHelper, type: :system

  config.before(:each, type: :request) do
    mock_oauth2_flow
  end

  config.before(:each, type: :system) do
    mock_oauth2_flow
  end
end
