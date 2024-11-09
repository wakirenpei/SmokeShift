class QuitSmokingRecord < ApplicationRecord
  belongs_to :user
  has_many :savings_goals, dependent: :destroy

  before_validation :set_daily_smoking_amount, on: :create

  validates :start_date, presence: true
  validates :daily_smoking_amount, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :end_date_after_start_date, if: :end_date

  scope :active, -> { where(end_date: nil) }
  scope :completed, -> { where.not(end_date: nil) }

  def start_time
    start_date.to_time
  end

  def active?
    end_date.nil?
  end

  def duration
    end_date ? (end_date - start_date) : (Time.current - start_date)
  end

  def calculate_savings
    # userのメソッドは使わず、保存された daily_smoking_amount を使用
    (daily_smoking_amount * duration / 1.day).round(0)
  end

  private

  def set_daily_smoking_amount
    # 全期間の喫煙記録から日数を計算
    smoking_days = user.smoking_records
                      .group('DATE(smoked_at)').count.size
    Rails.logger.info "Calculated smoking_days: #{smoking_days}"
  
    if smoking_days.zero?
      Rails.logger.info "No smoking days found, setting daily_smoking_amount to 0"
      return self.daily_smoking_amount = 0
    end
  
    # 全期間の総喫煙金額を計算
    total_spent = user.smoking_records.sum(:price_per_cigarette)
    Rails.logger.info "Total spent: #{total_spent}"
    
    # 1日あたりの平均金額を計算して保存
    amount = (total_spent.to_f / smoking_days).round
    Rails.logger.info "Calculated daily_smoking_amount: #{amount}"
    self.daily_smoking_amount = amount
  end

  def end_date_after_start_date
    if end_date.present? && end_date <= start_date
      errors.add(:end_date, "must be after the start date")
    end
  end
end