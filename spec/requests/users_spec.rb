RSpec.describe 'ユーザー', type: :request do
  describe '登録' do
    let(:valid_params) do
      {
        user: {
          email: 'test@example.com',
          password: 'password123',
          password_confirmation: 'password123',
          name: 'テストユーザー'
        }
      }
    end

    context '有効な属性の場合' do
      it 'ユーザーが作成される' do
        expect do
          post users_path, params: valid_params
        end.to change(User, :count).by(1)
      end

      it 'リダイレクトされる' do
        post users_path, params: valid_params
        expect(response).to redirect_to(smoker_smoking_records_path)
      end

      it 'フラッシュメッセージが表示される' do
        post users_path, params: valid_params
        expect(flash[:notice]).to eq 'ユーザー登録が完了しました'
      end

      it '作成されたユーザーの喫煙ステータスが正しい' do
        post users_path, params: valid_params
        expect(User.last.smoking_status).to eq 'smoker'
      end
    end
  end
end
