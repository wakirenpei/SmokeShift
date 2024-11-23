RSpec.describe 'ユーザーセッション', type: :request do
  describe 'ログイン' do
    let!(:user) { create(:user, password: 'password123') }

    context '正しい認証情報を使用した場合' do
      before do
        # 正しい認証情報を使ってログイン
        post login_path, params: {
          email: user.email,
          password: 'password123'
        }
      end

      it 'rootにリダイレクトされる' do
        expect(response).to redirect_to(root_path)
      end

      it 'ログイン成功のフラッシュメッセージが表示される' do
        follow_redirect!
        expect(flash[:notice]).to eq 'ログインしました。'
      end
    end
  end
end
