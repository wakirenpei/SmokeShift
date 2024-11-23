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
    smoking_days = calculate_smoking_days
    return self.daily_smoking_amount = 0 if smoking_days.zero?

    total_spent = calculate_total_spent
    self.daily_smoking_amount = calculate_average_daily_spent(total_spent, smoking_days)
  end

  def calculate_smoking_days
    smoking_days = user.smoking_records.group('DATE(smoked_at)').count.size
    Rails.logger.info "Calculated smoking_days: #{smoking_days}"
    smoking_days
  end

  def calculate_total_spent
    total_spent = user.smoking_records.sum(:price_per_cigarette)
    Rails.logger.info "Total spent: #{total_spent}"
    total_spent
  end

  def calculate_average_daily_spent(total_spent, smoking_days)
    amount = (total_spent.to_f / smoking_days).round
    Rails.logger.info "Calculated daily_smoking_amount: #{amount}"
    amount
  end

  def end_date_after_start_date
    return unless end_date.present? && end_date <= start_date

    errors.add(:end_date, 'must be after the start date')
  end
end
