require 'rails_helper'

RSpec.describe 'Smoker::Cigarettes', type: :request do
  let(:user) { create(:user) }
  
  before do
    login_user(user)
  end

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

    it 'タバコを登録できる' do
      expect {
        post smoker_cigarettes_path, params: valid_params
      }.to change(Cigarette, :count).by(1)
      expect(response).to redirect_to(smoker_cigarettes_path)
      expect(flash[:notice]).to eq 'タバコが正常に登録されました。'
    end
  end

  describe 'PATCH /update' do
    let!(:cigarette) { create(:cigarette, user: user) }
    let(:valid_params) do
      { cigarette: { brand: '新しいブランド' } }
    end

    it 'タバコ情報を更新できる' do
      patch smoker_cigarette_path(cigarette), params: valid_params
      expect(cigarette.reload.brand).to eq '新しいブランド'
      expect(response).to redirect_to(smoker_cigarettes_path)
      expect(flash[:notice]).to eq 'タバコ情報が更新されました。'
    end
  end

  describe 'GET /brands' do
    before do
      create(:cigarette_brand, name: 'テストブランド')
    end

    it 'ブランド情報を取得できる' do
      get brands_smoker_cigarettes_path, params: { query: 'テスト' }
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response.first['name']).to eq 'テストブランド'
    end
  end
end
