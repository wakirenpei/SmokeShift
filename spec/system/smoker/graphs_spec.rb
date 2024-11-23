RSpec.describe 'グラフ機能', type: :system do
  let(:user) { create(:user) }
  let(:cigarette) { create(:cigarette) }

  before do
    driven_by(:rack_test)
    create(:graph_record, user: user, cigarette: cigarette,
                          smoked_at: Time.current)
    create(:graph_record, user: user, cigarette: cigarette,
                          smoked_at: 1.day.ago)

    login_as_system_user user
    visit smoker_graphs_path
  end

  describe 'グラフの表示と操作' do
    it '喫煙グラフが表示されること' do
      expect(page).to have_content('喫煙グラフ')
    end

    it '期間別喫煙本数のグラフが表示されること' do
      expect(page).to have_content('期間別喫煙本数')
    end

    it '時間帯別喫煙本数のグラフが表示されること' do
      expect(page).to have_content('時間帯別喫煙本数')
    end
  end

  describe 'グラフの期間切替' do
    it '日別喫煙本数のグラフが表示されること' do
      within('#period_chart') do
        expect(page).to have_content('日別喫煙本数')
      end
    end

    it '週別喫煙本数のグラフが表示されること' do
      click_link '週別'
      within('#period_chart') do
        expect(page).to have_content('週別喫煙本数')
      end
    end

    it '月別喫煙本数のグラフが表示されること' do
      click_link '月別'
      within('#period_chart') do
        expect(page).to have_content('月別喫煙本数')
      end
    end
  end
end
