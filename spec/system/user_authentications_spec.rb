require 'rails_helper'

RSpec.describe "UserAuthentication", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe 'login process' do
    let!(:user) { create(:user, password: 'password123') }

    it 'logs in successfully' do
      visit login_path
      
      fill_in 'email', with: user.email
      fill_in 'password', with: 'password123'
      click_button 'ログイン'

      expect(page).to have_content('ログインしました。')
    end
  end

  describe 'registration process' do
    it 'registers new user successfully' do
      visit new_user_path
      
      fill_in 'user[email]', with: 'test@example.com'
      fill_in 'user[name]', with: 'Test User'
      fill_in 'user[password]', with: 'password123'
      fill_in 'user[password_confirmation]', with: 'password123'
      click_button '登録'

      expect(page).to have_content('ユーザー登録が完了しました')
      expect(User.last.smoking_status).to eq 'smoker'
    end
  end
end