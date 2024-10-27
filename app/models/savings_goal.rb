class SavingsGoal < ApplicationRecord
  belongs_to :user
  belongs_to :quit_smoking_record

  enum status: { active: 0, achieved: 1, discontinued: 2 }

  scope :active_goals, -> { where(status: :active) }
  scope :achieved_goals, -> { where(status: :achieved) }

  validates :target_amount, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true
  validates :achieved_at, presence: true, if: :achieved?
  validates :user_id, uniqueness: { scope: :status, :deleted_at, conditions: -> { active_goals }, message: "既に進行形の目標が存在します" }, if: :active?
  validate :achieved_at_should_be_after_start_date, if: -> { achieved? && achieved_at.present? }

  before_create :set_start_date
  before_save :set_achieved_at, if: :status_changed_to_achieved?
  after_save :check_achievement_status

  def progress_amount
    quit_smoking_record.calculate_savings
  end

  def remaining_amount
    target_amount - progress_amount
  end

  def progress_rate
    return 100.0 if achieved?
    return 0.0 if progress_amount.zero?
    
    (progress_amount.to_f / target_amount * 100).round(1)
  end

  def estimated_achievement_date
    return achieved_at if achieved?
    
    daily_savings = user.calculate_daily_potential_savings
    return nil if daily_savings.zero?
    
    remaining_days = (remaining_amount / daily_savings.to_f).ceil
    Date.current + remaining_days.days
  end

  # ステータス変更用の便利メソッド
  def discontinue!
    update!(status: :discontinued)
  end

  def achieve!
    update!(status: :achieved)
  end

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

  # 目標達成の自動チェック
  def check_achievement_status
    return if achieved? || discontinued?
    
    if progress_amount >= target_amount
      update(status: :achieved)
    end
  end

  # 禁煙記録が有効であることを確認
  def quit_smoking_record_must_be_active
    unless quit_smoking_record&.active?
      errors.add(:quit_smoking_record, "は有効な状態である必要があります")
    end
  end
end