RSpec.describe "ユーザー", type: :request do
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

    it '有効な属性で新規ユーザーが作成されること' do
      expect {
        post users_path, params: valid_params
      }.to change(User, :count).by(1)

      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq 'ユーザー登録が完了しました'
      expect(User.last.smoking_status).to eq 'smoker'
    end
  end
end