require 'rails_helper'

RSpec.describe SavingsGoal, type: :model do
  let(:user) { create(:user) }
  let(:quit_smoking_record) { create(:quit_smoking_record, :with_smoking_records, user: user) }

  describe 'バリデーション' do
    it '有効な属性値の場合は有効である' do
      savings_goal = build(:savings_goal, user: user, quit_smoking_record: quit_smoking_record)
      expect(savings_goal).to be_valid
    end
  end

  describe 'スコープ' do
    let!(:active_goal) { create(:savings_goal, user: user, quit_smoking_record: quit_smoking_record) }
    let!(:achieved_goal) { create(:savings_goal, :achieved, user: user, quit_smoking_record: quit_smoking_record) }

    it 'アクティブな目標を取得できること' do
      expect(SavingsGoal.active_goals).to include(active_goal)
    end

    it '達成済みの目標を取得できること' do
      expect(SavingsGoal.achieved_goals).to include(achieved_goal)
    end
  end
end