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
    it '喫煙データをグラフで確認できること' do
      expect(page).to have_content('喫煙グラフ')
      expect(page).to have_content('期間別喫煙本数')
      expect(page).to have_content('時間帯別喫煙本数')
    end

    it 'Turboを使用して期間を切り替えられること' do
      within('#period_chart') do
        expect(page).to have_content('日別喫煙本数')
      end

      click_link '週別'
      
      within('#period_chart') do
        expect(page).to have_content('週別喫煙本数')
      end

      click_link '月別'
      
      within('#period_chart') do
        expect(page).to have_content('月別喫煙本数')
      end
    end

    it '時間帯別の喫煙データを確認できること' do
      expect(page).to have_content('時間帯別喫煙本数')
    end
  end
end