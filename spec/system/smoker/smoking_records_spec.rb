RSpec.describe '喫煙記録管理', type: :system do
  let(:user) { create(:user) }
  let!(:cigarette) { create(:cigarette, user: user, brand: 'テストブランド') }
  
  before do
    driven_by(:rack_test)
    login_as_system_user(user)
    visit smoker_smoking_records_path
  end

  describe '記録の登録' do
    it '喫煙を記録できる' do
      find("input[type='radio'][id='cigarette_#{cigarette.id}']").click
      click_button '喫煙を記録'
      
      expect(page).to have_content('喫煙記録が追加されました')
      expect(page).to have_content(cigarette.brand)
    end
  end

  describe '統計情報の表示' do
    it '統計情報が正しく表示される' do
      create(:smoking_record, user: user, cigarette: cigarette, smoked_at: Time.current)
      visit smoker_smoking_records_path

      expect(page).to have_content("総合計金額")
      expect(page).to have_content("今日の合計金額")
      expect(page).to have_content("総本数")
      expect(page).to have_content("今日の本数")
    end
  end
end
