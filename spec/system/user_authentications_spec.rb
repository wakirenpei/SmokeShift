RSpec.describe 'UserAuthentication', type: :system do
  before do
    driven_by(:rack_test)
  end

  describe 'ログインプロセス' do
    context '正常なログイン' do
      let!(:user) { create(:user, password: 'password123') }

      it 'ログインに成功すること' do
        visit login_path

        fill_in 'email', with: user.email
        fill_in 'password', with: 'password123'
        click_button 'ログイン'

        expect(page).to have_content('ログインしました。')
      end
    end
  end

  describe '新規ユーザー登録プロセス' do
    context '有効な情報で登録する' do
      it '新規ユーザーが作成されること' do
        visit new_user_path

        fill_in 'user[email]', with: 'test@example.com'
        fill_in 'user[name]', with: 'Test User'
        fill_in 'user[password]', with: 'password123'
        fill_in 'user[password_confirmation]', with: 'password123'
        click_button '登録'

        expect(page).to have_content('ユーザー登録が完了しました')
      end

      it '喫煙者ステータスが設定されること' do
        visit new_user_path

        fill_in 'user[email]', with: 'test@example.com'
        fill_in 'user[name]', with: 'Test User'
        fill_in 'user[password]', with: 'password123'
        fill_in 'user[password_confirmation]', with: 'password123'
        click_button '登録'

        expect(User.last.smoking_status).to eq 'smoker'
      end
    end
  end
end
