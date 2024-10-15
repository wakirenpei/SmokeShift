class SmokingRecord < ApplicationRecord
  belongs_to :user
  belongs_to :cigarette

  validates :smoked_at, presence: true
  validates :price_per_cigarette, presence: true, numericality: { greater_than: 0 }
  validates :brand_name, presence: true

  before_validation :set_price_per_cigarette
  before_validation :set_brand_name
  before_validation :set_smoked_at

  scope :today, -> { where(smoked_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day) }
  scope :in_range, ->(range) { where(smoked_at: range.begin.beginning_of_day.in_time_zone('UTC')..range.end.end_of_day.in_time_zone('UTC')) }

  def self.total_amount
    sum(:price_per_cigarette)
  end

  def self.today_amount
    today.sum(:price_per_cigarette)
  end

  def self.total_count
    count
  end

  def self.today_count
    today.count 
  end

  def start_time
    smoked_at
  end

  # 指定された期間のデータを取得　(グラフ表示用)
  def self.fetch_data(user, period, start_date, end_date)
    range = date_range_for(period, start_date, end_date)
    data = user.smoking_records.in_range(range)
      .group_by_period(period, :smoked_at, time_zone: 'Tokyo', range: range)
      .count
    data
  end
  

  # 時間帯ごとのデータを取得　(グラフ表示用)
  def self.fetch_hourly_data(user)
    data = user.smoking_records
      .group_by_hour_of_day(:smoked_at, time_zone: 'Tokyo')
      .count

    (0..23).each { |hour| data[hour] ||= 0 }
    data
  end

  private

  def set_price_per_cigarette
    self.price_per_cigarette = cigarette.price_per_cigarette if cigarette
  end

  def set_brand_name
    self.brand_name = cigarette.brand if cigarette
  end

  def set_smoked_at
    self.smoked_at ||= Time.current
  end

  # 指定された期間の範囲を返す (グラフ表示用)
  def self.date_range_for(period, start_date, end_date)
    case period
    when :day then start_date..end_date
    when :week then (end_date.end_of_week - 4.weeks)..end_date.end_of_week
    when :month then (end_date.end_of_month - 5.months)..end_date.end_of_month
    end
  end
end