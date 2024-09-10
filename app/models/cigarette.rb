class Cigarette < ApplicationRecord
  belongs_to :user
  has_many :smoking_records, dependent: :destroy

  MAX_CIGARETTES_PER_USER = 2

  validates :brand, presence: true
  validates :quantity_per_pack, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :price_per_pack, presence: true, numericality: { only_integer: true, greater_than: 0 }
  
  validate :limit_cigarette_count, on: :create
  validate :price_per_cigarette_limit

  before_validation :calculate_price_per_cigarette

  private

  def calculate_price_per_cigarette
    return if price_per_pack.blank? || quantity_per_pack.blank?
    self.price_per_cigarette = (price_per_pack.to_f / quantity_per_pack).round(2)
  end

  def limit_cigarette_count
    if user.cigarettes.count >= MAX_CIGARETTES_PER_USER
      errors.add(:base, "最大#{MAX_CIGARETTES_PER_USER}種類のタバコしか登録できません")
    end
  end

  def price_per_cigarette_limit
    if price_per_cigarette && price_per_cigarette >= 100
      errors.add(:base, "1本あたりの価格が100円以上になっています。価格または本数を調整してください。")
    end
  end
end
