class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :authentications, :dependent => :destroy
  accepts_nested_attributes_for :authentications

  has_many :cigarettes, dependent: :destroy
  has_many :smoking_records, dependent: :destroy
  has_many :quit_smoking_records, dependent: :destroy
  has_many :savings_goals, dependent: :destroy

  enum smoking_status: { smoker: 0, non_smoker: 1 }

  validates :password, length: { minimum: 8 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :reset_password_token, uniqueness: true, allow_nil: true

  validates :name, presence: true, length: { maximum: 10 }
  validates :email, presence: true, uniqueness: true

  def calculate_daily_potential_savings
    return 0 if smoking_records.empty?

    # 喫煙した日ごとにグループ化して日数を数える
    smoking_days = smoking_records.group('DATE(smoked_at)').count.size

    # 総喫煙金額を喫煙日数で割る
    total_spent = smoking_records.sum(:price_per_cigarette)
    (total_spent.to_f / smoking_days).round(2)
  end

  def analyze_danger_hours
    records = smoking_records
    hours = records.group_by { |r| r.smoked_at.hour }
    danger_hours = hours.max_by(3) { |_, records| records.count }
    danger_hours.map { |hour, records| [hour, records.count] }.sort
  end

  def currently_quitting?
    quit_smoking_records.active.exists?
  end
end
