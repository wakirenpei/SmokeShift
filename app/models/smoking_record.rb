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
  scope :in_date_range, ->(start_date, end_date) { where(smoked_at: start_date.beginning_of_day..end_date.end_of_day) }
  scope :grouped_by_date, -> { group('DATE(smoked_at)') }

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

  def self.calendar_data(start_date, end_date)
    in_date_range(start_date, end_date)
      .grouped_by_date
      .select('DATE(smoked_at) as date, COUNT(*) as count, SUM(price_per_cigarette) as amount')
      .each_with_object({}) do |record, hash|
        hash[record.date.to_date] = { count: record.count, amount: record.amount }
      end
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
end