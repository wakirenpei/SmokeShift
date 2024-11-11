require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    it '有効な属性値の場合は有効であること' do
      user = build(:user)
      expect(user).to be_valid
    end

    it '喫煙ステータスのデフォルトがsmokerであること' do
      user = create(:user)
      expect(user.smoking_status).to eq 'smoker'
    end
  end

  describe '認証' do
    it '正しい認証情報で認証できること' do
      user = create(:user, password: 'password123')
      authenticated_user = User.authenticate(user.email, 'password123')
      expect(authenticated_user).to eq(user)
    end
  end
end