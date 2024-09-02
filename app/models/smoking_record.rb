class SmokingRecord < ApplicationRecord
  belongs_to :user
  belongs_to :cigarette

  validates :user, presence: true
  validates :cigarette, presence: true
  validates :price_per_cigarette, presence: true, numericality: { greater_than: 0 }
  validates :smoked_at, presence: true

  before_validation :set_price_per_cigarette

  scope :today, -> { where(smoked_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day) }

  private

  def set_price_per_cigarette
    self.price_per_cigarette = cigarette.price_per_cigarette if cigarette
  end
end