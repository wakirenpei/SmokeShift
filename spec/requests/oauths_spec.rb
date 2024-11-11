# spec/requests/oauths_spec.rb
require 'rails_helper'

RSpec.describe "LINE認証", type: :request do
  describe "認証フロー" do
    context '新規ユーザーの場合' do
      it 'ユーザーが作成されること' do
        expect {
          get oauth_callback_path, params: { 
            provider: 'line', 
            code: 'valid_authorization_code',
            state: SecureRandom.hex(16)
          }
        }.to change(User, :count).by(1)
      end
    end
  end
end