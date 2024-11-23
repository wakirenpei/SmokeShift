RSpec.describe 'Smoker::Graphs', type: :request do
  let(:user) { create(:user) }
  let(:cigarette) { create(:cigarette) }

  before do
    login_user user
    create_list(:graph_record, 3, user: user, cigarette: cigarette, smoked_at: Time.current)
  end

  describe 'GET #index' do
    context 'period未指定の場合' do
      it '日別喫煙本数が表示される' do
        get smoker_graphs_path
        expect(response.body).to include('日別喫煙本数')
      end

      it 'HTTPステータスが200である' do
        get smoker_graphs_path
        expect(response).to have_http_status(:success)
      end
    end

    context 'periodが週別の場合' do
      it '週別喫煙本数が表示される' do
        get smoker_graphs_path(period: 'weekly')
        expect(response.body).to include('週別喫煙本数')
      end

      it 'HTTPステータスが200である' do
        get smoker_graphs_path(period: 'weekly')
        expect(response).to have_http_status(:success)
      end
    end

    context 'レスポンス内容の検証' do
      it '期間別喫煙本数が表示される' do
        get smoker_graphs_path
        expect(response.body).to include('期間別喫煙本数')
      end

      it '時間帯別喫煙本数が表示される' do
        get smoker_graphs_path
        expect(response.body).to include('時間帯別喫煙本数')
      end
    end

    context 'グラフデータのレスポンス確認' do
      it '期間別グラフ用データがレスポンスに含まれる' do
        get smoker_graphs_path
        expect(response.body).to include('期間別喫煙本数')
      end

      it '時間帯別グラフ用データがレスポンスに含まれる' do
        get smoker_graphs_path
        expect(response.body).to include('時間帯別喫煙本数')
      end
    end
  end
end
