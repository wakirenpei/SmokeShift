RSpec.describe 'Smoker::Cigarettes', type: :request do
  let(:user) { create(:user) }

  before { login_user(user) }

  describe 'GET /index' do
    it '正常にレスポンスを返す' do
      get smoker_cigarettes_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /create' do
    let(:valid_params) do
      { cigarette: { brand: 'テストブランド', price_per_pack: 500, quantity_per_pack: 20 } }
    end

    context '正常なリクエストの場合' do
      it 'タバコを登録できる' do
        expect do
          post smoker_cigarettes_path, params: valid_params
        end.to change(Cigarette, :count).by(1)
      end

      it 'リダイレクトされる' do
        post smoker_cigarettes_path, params: valid_params
        expect(response).to redirect_to(smoker_cigarettes_path)
      end

      it 'フラッシュメッセージが表示される' do
        post smoker_cigarettes_path, params: valid_params
        expect(flash[:notice]).to eq 'タバコが正常に登録されました。'
      end
    end
  end

  describe 'PATCH /update' do
    let!(:cigarette) { create(:cigarette, user: user) }
    let(:valid_params) { { cigarette: { brand: '新しいブランド' } } }

    it 'タバコ情報を更新できる' do
      patch smoker_cigarette_path(cigarette), params: valid_params
      expect(cigarette.reload.brand).to eq '新しいブランド'
    end

    it 'リダイレクトされる' do
      patch smoker_cigarette_path(cigarette), params: valid_params
      expect(response).to redirect_to(smoker_cigarettes_path)
    end

    it 'フラッシュメッセージが表示される' do
      patch smoker_cigarette_path(cigarette), params: valid_params
      expect(flash[:notice]).to eq 'タバコ情報が更新されました。'
    end
  end

  describe 'GET /brands' do
    before { create(:cigarette_brand, name: 'テストブランド') }

    it 'ブランド情報を取得できる' do
      get brands_smoker_cigarettes_path, params: { query: 'テスト' }
      expect(response).to have_http_status(:success)
    end

    it '取得したブランド情報が正しい' do
      get brands_smoker_cigarettes_path, params: { query: 'テスト' }
      json_response = response.parsed_body
      expect(json_response.first['name']).to eq 'テストブランド'
    end
  end
end
