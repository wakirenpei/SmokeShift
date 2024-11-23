RSpec.describe '禁煙記録管理システム', type: :system do
  let(:user) { create(:user) }

  before do
    driven_by(:rack_test)
    login_as_system_user(user)
  end

  describe '禁煙の開始' do
    it 'ユーザーが禁煙を開始できる' do
      create(:smoking_record, user: user)
      visit non_smoker_quit_smoking_records_path
      first(:button, '禁煙を開始').click

      expect(page).to have_content('禁煙を開始しました。頑張りましょう！')
    end
  end

  describe '禁煙の終了' do
    it 'ユーザーが禁煙を終了できる' do
      create(:quit_smoking_record, user: user, start_date: Time.current)
      visit non_smoker_quit_smoking_records_path
      click_button '禁煙を終了'

      expect(page).to have_content('禁煙を終了します。お疲れ様でした！')
    end
  end
end
