RSpec.describe 'タバコ管理', type: :system do
  let(:user) { create(:user) }
  
  before do
    driven_by(:rack_test)
    login_as_system_user(user)
    visit smoker_cigarettes_path
  end

  describe 'タバコ一覧' do
    it 'タバコ一覧を表示できる' do
      create(:cigarette, user: user, brand: 'テストブランド')
      visit smoker_cigarettes_path
      expect(page).to have_content('テストブランド')
    end
  end

  describe 'タバコ登録' do
    context 'モーダルでの登録操作' do
      before do
        find('label', text: '新しいタバコを追加').click
      end

      it 'タバコを新規登録できる' do
        within('.modal', text: '新しいタバコを登録') do
          fill_in '銘柄', with: 'テストブランド'
          fill_in '1箱の値段', with: '500'
          fill_in '1箱の本数', with: '20'
          click_button '登録'
        end

        expect(page).to have_content('タバコが正常に登録されました')
        expect(page).to have_content('テストブランド')
      end

      it 'モーダル操作ができる' do
        modal = find('.modal', text: '新しいタバコを登録')
        expect(modal).to have_content('新しいタバコを登録')
        expect(modal).to have_field('銘柄')
        expect(modal).to have_field('1箱の値段')
        expect(modal).to have_field('1箱の本数')

        within(modal) do
          find('label[for="new-cigarette-modal"]').click
        end

        expect(find('#new-cigarette-modal', visible: false)).not_to be_checked
      end
    end

    context '登録上限の確認' do
      it '最大登録数に達すると登録ボタンが非表示になる' do
        Cigarette::MAX_CIGARETTES_PER_USER.times do |i|
          create(:cigarette, user: user, brand: "テストブランド#{i + 1}")
        end
        
        visit smoker_cigarettes_path
        expect(page).not_to have_content('新しいタバコを追加')
        expect(page).to have_content('登録可能な上限に達しました（最大2種類）')
      end
    end

    context '登録内容の確認' do
      it '必要な情報が表示される' do
        create(:cigarette, 
          user: user,
          brand: 'テストブランド',
          price_per_pack: 500,
          quantity_per_pack: 20
        )
        
        visit smoker_cigarettes_path
        
        expect(page).to have_content('テストブランド')
        expect(page).to have_content('¥500 / 20本')
        expect(page).to have_content('1本あたり: ¥25')
      end

      it '編集リンクが表示される' do
        cigarette = create(:cigarette, user: user, brand: 'テストブランド')
        visit smoker_cigarettes_path
        
        expect(page).to have_link('編集', href: edit_smoker_cigarette_path(cigarette))
      end
    end
  end
end