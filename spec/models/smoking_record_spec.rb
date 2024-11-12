require 'rails_helper'

RSpec.describe SmokingRecord, type: :model do
  describe 'バリデーション' do
    let(:user) { create(:user) }
    let(:cigarette) { create(:cigarette, user: user) }
    let(:smoking_record) { build(:smoking_record, user: user, cigarette: cigarette) }

    it '有効な属性値の場合は有効である' do
      expect(smoking_record).to be_valid
    end
  end

  describe '集計メソッド' do
    let(:user) { create(:user) }
    let(:cigarette) { create(:cigarette, user: user, price_per_pack: 500, quantity_per_pack: 20) }
    
    before do
      create(:smoking_record, user: user, cigarette: cigarette)
      create(:smoking_record, user: user, cigarette: cigarette)
    end

    it '合計金額を計算できる' do
      expect(user.smoking_records.total_amount).to eq 50
    end

    it '合計本数を計算できる' do
      expect(user.smoking_records.total_count).to eq 2
    end
  end
end
