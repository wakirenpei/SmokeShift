require 'rails_helper'

RSpec.describe QuitSmokingRecord, type: :model do
  let(:user) { create(:user) }

  describe 'バリデーション' do
    context '喫煙記録がある場合' do
      before do
        create(:smoking_record, user: user, price_per_cigarette: 25)
        create(:smoking_record, user: user, price_per_cigarette: 25, 
                smoked_at: 1.day.ago)
      end

      let(:quit_smoking_record) { build(:quit_smoking_record, user: user) }

      it '有効な属性値の場合は有効である' do
        expect(quit_smoking_record).to be_valid
        expect(quit_smoking_record.daily_smoking_amount).to eq(25)
      end
    end
  end

  describe 'スコープ' do
    let!(:active_record) { create(:quit_smoking_record, :with_smoking_records, user: user) }
    let!(:completed_record) do 
      create(:quit_smoking_record, :with_smoking_records, user: user, 
              start_date: 2.days.ago, end_date: Time.current)
    end

    it 'activeスコープはend_dateがnilのレコードを返す' do
      expect(QuitSmokingRecord.active).to include(active_record)
      expect(QuitSmokingRecord.active).to_not include(completed_record)
    end

    it 'completedスコープはend_dateが存在するレコードを返す' do
      expect(QuitSmokingRecord.completed).to include(completed_record)
      expect(QuitSmokingRecord.completed).to_not include(active_record)
    end
  end

  describe 'メソッド' do
    context '喫煙記録がある場合' do
      let(:quit_smoking_record) do
        create(:quit_smoking_record, :with_smoking_records, 
                user: user, start_date: 2.days.ago)
      end

      it 'calculate_savingsメソッドが正しい金額を計算する' do
        expect(quit_smoking_record.daily_smoking_amount).to eq(25)
        expect(quit_smoking_record.calculate_savings).to eq(50)
      end

      it 'durationメソッドが禁煙期間を計算する' do
        expect(quit_smoking_record.duration).to be_within(1.second).of(2.days)
      end
    end
  end
end