RSpec.describe "ユーザーセッション", type: :request do
  describe 'ログイン' do
    let!(:user) { create(:user, password: 'password123') }

    it '正しい資格情報で正常にログインできること' do
      post login_path, params: { 
        email: user.email, 
        password: 'password123'
      }
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq 'ログインしました。'
    end
  end
end