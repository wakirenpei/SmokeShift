RSpec.describe '目標設定機能', type: :system do
  let(:user) { create(:user) }
  let(:quit_smoking_record) { create(:quit_smoking_record, :with_smoking_records, user: user) }

  before do
    driven_by(:rack_test)
    login_as_system_user user
    quit_smoking_record
  end

  describe '目標の設定と管理' do
    it '新しい目標を設定できること' do
      visit non_smoker_savings_goals_path
      
      first('label[for="new-goal-modal"]', text: '新しい目標を設定する').click
      
      within('#new-goal-modal + .modal') do
        within('.modal-box') do
          fill_in '目標金額', with: 10000
          click_button '設定'
        end
      end

      expect(page).to have_content '貯金目標を設定しました'
      expect(page).to have_content '目標金額: 10,000円'
    end

    it '目標を編集できること' do
      savings_goal = create(:savings_goal, user: user, quit_smoking_record: quit_smoking_record)
      visit non_smoker_savings_goals_path
      
      first('.btn.btn-primary', text: '編集').click
      
      within("#edit-goal-modal-#{savings_goal.id} + .modal") do
        within('.modal-box') do
          fill_in '目標金額', with: 20000
          click_button '更新'
        end
      end

      expect(page).to have_content '貯金目標を更新しました'
      expect(page).to have_content '目標金額: 20,000円'
    end
  end
end