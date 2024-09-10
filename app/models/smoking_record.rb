class SmokingRecord < ApplicationRecord
  belongs_to :user
  belongs_to :cigarette

  validates :smoked_at, presence: true

  before_validation :set_price_per_cigarette
  before_validation :set_smoked_at

  scope :today, -> { where(smoked_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day) }

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

  private

  def set_price_per_cigarette
    self.price_per_cigarette = cigarette.price_per_cigarette if cigarette
  end

  def set_smoked_at
    self.smoked_at ||= Time.current
  end
end