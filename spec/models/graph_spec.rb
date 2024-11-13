require 'rails_helper'

RSpec.describe SmokingRecord, type: :model do
  let(:user) { create(:user) }
  let(:cigarette) { create(:cigarette) }
  let(:start_date) { Date.today - 6.days }
  let(:end_date) { Date.today }

  describe '.fetch_data' do
    before do
      create(:graph_record, user: user, cigarette: cigarette, 
              smoked_at: Time.current)
      create(:graph_record, user: user, cigarette: cigarette, 
              smoked_at: 1.day.ago)
      create(:graph_record, user: user, cigarette: cigarette, 
              smoked_at: 1.week.ago)
      create(:graph_record, user: user, cigarette: cigarette, 
              smoked_at: 1.month.ago)
    end

    context '日別データの取得' do
      it '正しい日別の喫煙本数が取得できること' do
        data = SmokingRecord.fetch_data(user, :day, start_date, end_date)
        expect(data).to be_present
        expect(data.values.sum).to be > 0
      end
    end

    context '週別データの取得' do
      it '正しい週別の喫煙本数が取得できること' do
        data = SmokingRecord.fetch_data(user, :week, start_date, end_date)
        expect(data).to be_present
        expect(data.values.sum).to be > 0
      end
    end

    context '月別データの取得' do
      it '正しい月別の喫煙本数が取得できること' do
        data = SmokingRecord.fetch_data(user, :month, start_date, end_date)
        expect(data).to be_present
        expect(data.values.sum).to be > 0
      end
    end
  end

  describe '.fetch_hourly_data' do
    before do
      create(:graph_record, user: user, cigarette: cigarette, 
              smoked_at: Time.current.beginning_of_day + 9.hours)  # 9時のデータ
      create(:graph_record, user: user, cigarette: cigarette, 
              smoked_at: Time.current.beginning_of_day + 15.hours) # 15時のデータ
    end

    it '24時間分のデータが取得できること' do
      data = SmokingRecord.fetch_hourly_data(user)
      expect(data.keys).to match_array((0..23).to_a)
    end

    it '各時間帯の喫煙本数が正しくカウントされること' do
      data = SmokingRecord.fetch_hourly_data(user)
      expect(data[9]).to eq(1)  # 9時台は1本
      expect(data[15]).to eq(1) # 15時台は1本
      expect(data[0]).to eq(0)  # 0時台は0本
    end
  end
end