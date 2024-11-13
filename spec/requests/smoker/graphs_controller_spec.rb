RSpec.describe "Smoker::Graphs", type: :request do
  let(:user) { create(:user) }
  let(:cigarette) { create(:cigarette) }
  
  before do
    login_user user
  end

  describe 'GET #index' do
    before do
      create_list(:graph_record, 3, user: user, cigarette: cigarette, 
                  smoked_at: Time.current)
    end

    context '正常系' do
      it 'period未指定の場合はdailyが表示されること' do
        get smoker_graphs_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include('日別喫煙本数')
      end

      it '指定したperiodの内容が表示されること' do
        get smoker_graphs_path(period: 'weekly')
        expect(response).to have_http_status(:success)
        expect(response.body).to include('週別喫煙本数')
      end

      it '日付範囲のデータが表示されること' do
        get smoker_graphs_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include('期間別喫煙本数')
        expect(response.body).to include('時間帯別喫煙本数')
      end

      it 'グラフ用の各データが表示されること' do
        get smoker_graphs_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include('期間別喫煙本数')
        expect(response.body).to include('時間帯別喫煙本数')
      end
    end
  end
end