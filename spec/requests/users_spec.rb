require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe 'registration' do
    let(:valid_params) do
      {
        user: {
          email: 'test@example.com',
          password: 'password123',
          password_confirmation: 'password123',
          name: 'Test User'
        }
      }
    end

    it 'creates a new user with valid attributes' do
      expect {
        post users_path, params: valid_params
      }.to change(User, :count).by(1)

      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq 'ユーザー登録が完了しました'
      expect(User.last.smoking_status).to eq 'smoker'
    end
  end
end
