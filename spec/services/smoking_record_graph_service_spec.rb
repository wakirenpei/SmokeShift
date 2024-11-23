RSpec.describe SmokingRecordGraphService do
  let(:user) { create(:user) }
  let(:start_date) { Time.zone.today - 6.days }
  let(:end_date) { Time.zone.today }

  describe '.fetch_daily_data' do
    before do
      create(:smoking_record, user: user, cigarette: create(:cigarette), smoked_at: Time.current)
      create(:smoking_record, user: user, cigarette: create(:cigarette), smoked_at: 1.day.ago)
      create(:smoking_record, user: user, cigarette: create(:cigarette), smoked_at: 2.days.ago)
    end

    it 'データが存在すること' do
      data = described_class.fetch_daily_data(user, start_date, end_date)
      expect(data).to be_present
    end

    it '日別の喫煙本数が正しいこと' do
      data = described_class.fetch_daily_data(user, start_date, end_date)
      expect(data.values.sum).to eq(3)
    end
  end

  describe '.fetch_weekly_data' do
    before do
      create(:smoking_record, user: user, cigarette: create(:cigarette), smoked_at: 1.week.ago)
      create(:smoking_record, user: user, cigarette: create(:cigarette), smoked_at: 2.weeks.ago)
      create(:smoking_record, user: user, cigarette: create(:cigarette), smoked_at: 3.weeks.ago)
    end

    it 'データが存在すること' do
      data = described_class.fetch_weekly_data(user, start_date, end_date)
      expect(data).to be_present
    end

    it '週別の喫煙本数が正しいこと' do
      data = described_class.fetch_weekly_data(user, start_date, end_date)
      expect(data.values.sum).to eq(3)
    end
  end

  describe '.fetch_hourly_data' do
    before do
      create(:smoking_record, user: user, cigarette: create(:cigarette),
                              smoked_at: Time.current.beginning_of_day + 9.hours)
      create(:smoking_record, user: user, cigarette: create(:cigarette),
                              smoked_at: Time.current.beginning_of_day + 15.hours)
    end

    it '24時間分のデータが取得できること' do
      data = described_class.fetch_hourly_data(user)
      expect(data.keys).to match_array((0..23).to_a)
    end

    it '9時台の喫煙本数が正しいこと' do
      data = described_class.fetch_hourly_data(user)
      expect(data[9]).to eq(1)
    end

    it '15時台の喫煙本数が正しいこと' do
      data = described_class.fetch_hourly_data(user)
      expect(data[15]).to eq(1)
    end

    it '0時台の喫煙本数が正しいこと' do
      data = described_class.fetch_hourly_data(user)
      expect(data[0]).to eq(0)
    end
  end
end
