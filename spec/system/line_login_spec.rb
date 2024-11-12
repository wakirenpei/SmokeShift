RSpec.describe "LINE認証", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe 'ログイン機能' do
    it 'LINEログインが成功すること' do
      visit login_path
      click_link 'LINEでログイン'

      visit oauth_callback_path(
        provider: 'line',
        code: 'valid_authorization_code',
        state: SecureRandom.hex(16)
      )

      expect(page).to have_content 'Lineでアカウントを作成しログインしました。'
    end

    context '既存ユーザーの場合' do
      let!(:user) { create(:user) }
      let!(:authentication) { create(:authentication, user: user, provider: 'line', uid: '12345') }

      it 'ログインできること' do
        visit login_path
        click_link 'LINEでログイン'

        visit oauth_callback_path(
          provider: 'line',
          code: 'valid_authorization_code',
          state: SecureRandom.hex(16)
        )

        expect(page).to have_content 'Lineでログインしました。'
      end
    end
  end
end