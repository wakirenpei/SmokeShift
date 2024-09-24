class QuitSmokingRecord < ApplicationRecord
  belongs_to :user

  validates :start_date, presence: true
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

  # 新しく追加されたメソッド
  def calculate_savings
    daily_savings = user.calculate_daily_potential_savings
    (daily_savings * duration / 1.day).round(0)
  end

  private

  def end_date_after_start_date
    if end_date.present? && end_date <= start_date
      errors.add(:end_date, "must be after the start date")
    end
  end
end