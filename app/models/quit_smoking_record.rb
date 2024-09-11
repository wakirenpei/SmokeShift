class QuitSmokingRecord < ApplicationRecord
  belongs_to :user

  validates :start_date, presence: true
  validate :end_date_after_start_date, if: :end_date

  scope :active, -> { where(end_date: nil) }
  scope :completed, -> { where.not(end_date: nil) }

  def active?
    end_date.nil?
  end

  private

  def end_date_after_start_date
    if end_date.present? && end_date <= start_date
      errors.add(:end_date, "must be after the start date")
    end
  end
end