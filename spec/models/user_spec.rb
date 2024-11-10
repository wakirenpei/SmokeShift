require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'has smoker as default smoking_status' do
      user = create(:user)
      expect(user.smoking_status).to eq 'smoker'
    end
  end

  describe 'authentication' do
    it 'authenticates with correct credentials' do
      user = create(:user, password: 'password123')
      authenticated_user = User.authenticate(user.email, 'password123')
      expect(authenticated_user).to eq(user)
    end
  end
end