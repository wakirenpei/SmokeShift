RSpec.describe OauthsController, type: :controller do
  describe 'OAuthログインと新規登録' do
    let!(:existing_user) { create(:user, email: 'line_user@example.com') }

    context 'LINEを使用した新規登録で成功した場合' do
      before do
        # モックされたOAuthフローの処理
        allow(controller).to receive(:login_from).with('line').and_return(nil)
        allow(controller).to receive(:create_from).with('line').and_return(existing_user)

        # OAuthコールバックの実行
        get :callback, params: { provider: 'line' }
      end

      it '喫煙記録のページにリダイレクトされる' do
        expect(response).to redirect_to(smoker_smoking_records_path)
      end

      it '新規登録成功のフラッシュメッセージが表示される' do
        expect(flash[:notice]).to eq 'Lineでアカウントを作成しログインしました。'
      end
    end

    context 'LINEを使用した既存ユーザーのログインで成功した場合' do
      before do
        # モックされたOAuthフローの処理
        allow(controller).to receive(:login_from).with('line').and_return(existing_user)

        # OAuthコールバックの実行
        get :callback, params: { provider: 'line' }
      end

      it 'rootにリダイレクトされる' do
        expect(response).to redirect_to(root_path)
      end

      it 'ログイン成功のフラッシュメッセージが表示される' do
        expect(flash[:notice]).to eq 'Lineでログインしました。'
      end
    end
  end
end
