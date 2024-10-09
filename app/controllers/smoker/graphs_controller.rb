class Smoker::GraphsController < ApplicationController
  before_action :require_login
  def index
    # 日、週、月、のデータを取得
    @daily_smoking_count = smoking_records.group_by_day(:smoked_at, range: 30.days.ago..Time.current).count
    @weekly_smoking_count = smoking_records.group_by_week(:smoked_at, range: 12.weeks.ago..Time.current).count
    @monthly_smoking_count = smoking_records.group_by_month(:smoked_at, range: 12.months.ago..Time.current).count

    # 喫煙時間
    @hourly_smoking_count = smoking_records.group_by_hour_of_day(:smoked_at).count

    # 銘柄の割合
    @brand_smoking_count = smoking_records.group(:brand_name).count
  end

  private

  def current_smoking_record
    current_user.smoking_records
  end
end
