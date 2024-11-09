class SavingsGoal < ApplicationRecord
  belongs_to :user
  belongs_to :quit_smoking_record

  enum status: { active: 0, achieved: 1, discontinued: 2 }

  scope :active_goals, -> { where(status: :active) }
  scope :achieved_goals, -> { where(status: :achieved) }

  # 基本バリデーション
  validates :target_amount, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true
  validates :achieved_at, presence: true, if: :achieved?
  
  # ユニーク制約
  validates :user_id, uniqueness: { 
    scope: [:status], 
    conditions: -> { active_goals }, 
    message: "既に進行形の目標が存在します" 
  }, if: :active?

  # カスタムバリデーション
  validate :achieved_at_should_be_after_start_date, if: -> { achieved? && achieved_at.present? }
  validate :quit_smoking_record_must_be_active, if: :active?
  validate :target_amount_must_exceed_current_savings, if: :active?

  # コールバック
  before_create :set_start_date
  before_save :set_achieved_at, if: :status_changed_to_achieved?
  after_save :check_achievement_status

  # 進捗関連のメソッド
  def progress_amount
    quit_smoking_record.calculate_savings
  end

  def remaining_amount
    [target_amount - progress_amount, 0].max
  end

  def progress_rate
    return 100.0 if achieved?
    return 0.0 if progress_amount.zero?
    
    rate = (progress_amount.to_f / target_amount * 100).round(1)
    [rate, 100.0].min
  end

  def estimated_achievement_date
    return achieved_at if achieved?
    return Date.current if progress_rate >= 100

    daily_savings = quit_smoking_record&.daily_smoking_amount
    return nil if daily_savings.zero?

    remaining_days = (remaining_amount / daily_savings.to_f).ceil
    Date.current + remaining_days.days
  end

  # ステータス変更メソッド
  def discontinue!
    update!(status: :discontinued)
  end

  def achieve!
    update!(status: :achieved)
  end

  def check_and_update_achievement
    return if achieved? || discontinued?
    
    if progress_amount >= target_amount
      update_columns(
        status: :achieved,
        achieved_at: Time.current
      )
    end
  end

  def achievement_duration
    return 0 unless achieved_at && start_date
    achieved_at.to_time - start_date.to_time
  end

  private

  def target_amount_must_exceed_current_savings
    return unless quit_smoking_record
    
    current_savings = quit_smoking_record.calculate_savings
    if target_amount && target_amount <= current_savings
      errors.add(:target_amount, 
                "は現在の節約額(#{ActionController::Base.helpers.number_to_currency(current_savings)})を超える金額を設定してください")
    end
  end

  def set_start_date
    self.start_date = Time.zone.now
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

  def check_achievement_status
    check_and_update_achievement
  end

  def quit_smoking_record_must_be_active
    unless quit_smoking_record&.active?
      errors.add(:quit_smoking_record, "は有効な状態である必要があります")
    end
  end
end