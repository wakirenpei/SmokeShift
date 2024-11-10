require 'rails_helper'

RSpec.describe "UserSessions", type: :request do
  describe 'login' do
    let!(:user) { create(:user, password: 'password123') }

    it 'logs in successfully with correct credentials' do
      post login_path, params: { 
        email: user.email, 
        password: 'password123'
      }
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq 'ログインしました。'
    end
  end
end