class SavingsGoal < ApplicationRecord
  belongs_to :user
  belongs_to :quit_smoking_record

  enum status: { active: 0, achieved: 1, discontinued: 2 }

  scope :active_goals, -> { where(status: :active, deleted_at: nil) }
  scope :without_deleted, -> { where(deleted_at: nil) }

  validates :target_amount, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true
  validates :achieved_at, presence: true, if: :achieved?
  validates :user_id, uniqueness: { scope: [:status, :deleted_at], conditions: -> { active_goals }, message: "既に進行形の目標が存在します" }, if: :active?
  validate :achieved_at_should_be_after_start_date, if: -> { achieved? && achieved_at.present? }

  before_create :set_start_date
  before_save :set_achieved_at, if: :status_changed_to_achieved?

  private

  def set_start_date
    self.start_date = Date.current
  end

  def achieved_at_should_be_after_start_date
    if achieved_at.present? && achieved_at.to_date < start_date
      errors.add(:achieved_at, "は開始日より後の日付である必要があります")
    end
  end

  def status_changed_to_achieved?
    status_changed? && achieved?
  end

  def set_achieved_at
    self.achieved_at ||= Time.current
  end
end
