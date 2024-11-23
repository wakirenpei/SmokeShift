RSpec.describe 'タバコ管理', type: :system do
  let(:user) { create(:user) }
  let(:cigarette) { create(:cigarette, user: user) }

  before do
    driven_by(:rack_test)
    login_as_system_user(user)
    visit smoker_cigarettes_path
  end

  describe 'タバコ一覧' do
    it 'タバコ一覧を表示できる' do
      cigarette # FactoryBotを利用して事前に作成
      visit smoker_cigarettes_path
      expect(page).to have_content(cigarette.brand)
    end
  end

  describe 'タバコ登録' do
    context '新しいタバコを登録する' do
      it 'タバコが正常に登録されること' do
        find('label', text: '新しいタバコを追加').click

        within('.modal', text: '新しいタバコを登録') do
          fill_in '銘柄', with: 'テストブランド'
          fill_in '1箱の値段', with: '500'
          fill_in '1箱の本数', with: '20'
          click_button '登録'
        end

        expect(page).to have_content('タバコが正常に登録されました')
      end

      it 'タバコの銘柄が表示されること' do
        find('label', text: '新しいタバコを追加').click

        within('.modal', text: '新しいタバコを登録') do
          fill_in '銘柄', with: 'テストブランド'
          fill_in '1箱の値段', with: '500'
          fill_in '1箱の本数', with: '20'
          click_button '登録'
        end

        expect(page).to have_content('テストブランド')
      end
    end

    context '登録上限に達する' do
      it '最大登録数に達すると登録ボタンが非表示になること' do
        Cigarette::MAX_CIGARETTES_PER_USER.times { create(:cigarette, user: user) }

        visit smoker_cigarettes_path
        expect(page).to have_content('登録可能な上限に達しました（最大2種類）')
      end
    end

    context '登録内容の確認' do
      before do
        cigarette # 事前にファクトリでタバコを作成
        visit smoker_cigarettes_path
      end

      it 'ブランド名が表示されること' do
        expect(page).to have_content(cigarette.brand)
      end

      it '1箱の価格と本数が表示されること' do
        expect(page).to have_content("¥#{cigarette.price_per_pack} / #{cigarette.quantity_per_pack}本")
      end

      it '編集アイコンが表示されること' do
        expect(page).to have_selector("a[href='#{edit_smoker_cigarette_path(cigarette)}'] i.fa-edit")
      end
    end
  end
end
