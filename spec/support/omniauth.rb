# spec/support/oauth_helper.rb
module OAuthHelper
  def mock_oauth2_flow
    # 最初にアクセストークンをモック
    access_token = double(OAuth2::AccessToken)
    user_response = double('Response', 
      body: {
        userId: '12345',
        displayName: 'test_user'
      }.to_json
    )
    allow(access_token).to receive(:get).and_return(user_response)

    # auth_codeストラテジーをモック
    auth_code = double(OAuth2::Strategy::AuthCode)
    allow(auth_code).to receive(:get_token).and_return(access_token)
    allow(auth_code).to receive(:authorize_url).and_return('http://example.com/auth')

    # OAuth2クライアントをモック
    oauth2_client = double(OAuth2::Client)
    allow(oauth2_client).to receive(:auth_code).and_return(auth_code)
    allow(OAuth2::Client).to receive(:new).and_return(oauth2_client)
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