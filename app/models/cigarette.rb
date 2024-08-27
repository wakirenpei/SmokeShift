class Cigarette < ApplicationRecord
  belongs_to :user

  validates :brand, presence: true
  validates :quantity_per_pack, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :price_per_pack, presence: true, numericality: { only_integer: true, greater_than: 0 }

  validate :limit_cigarette_count, on: :create
  validate :validate_price_per_cigarette

  before_validation :calculate_price_per_cigarette

  private

  def calculate_price_per_cigarette
    return if price_per_pack.blank? || quantity_per_pack.blank?
    @calculated_price = (price_per_pack.to_f / quantity_per_pack)
  end

  def validate_price_per_cigarette
    return if @calculated_price.nil?

    if @calculated_price < 0
      errors.add(:base, "計算結果がマイナスになります。正しい値を入力してください。")
    elsif @calculated_price >= 100
      errors.add(:base, "計算結果が100円以上になります。正しい値を入力してください。")
    else
      self.price_per_cigarette = @calculated_price.round(2)
    end
  end

  def limit_cigarette_count
    if user.cigarettes.count >= 2
      errors.add(:base, "最大2種類のタバコしか登録できません")
    end
  end
end