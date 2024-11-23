class Smoker::GraphsController < ApplicationController
  before_action :require_login
  before_action :set_date_range

  def index
    @period = params[:period] || 'daily'
    @daily_smoking_data = SmokingRecordGraphService.fetch_daily_data(current_user, @start_date, @end_date)
    @weekly_smoking_data = SmokingRecordGraphService.fetch_weekly_data(current_user, @start_date, @end_date)
    @monthly_smoking_data = SmokingRecordGraphService.fetch_monthly_data(current_user, @start_date, @end_date)
    @hourly_smoking_data = SmokingRecordGraphService.fetch_hourly_data(current_user)
  end

  private

  def set_date_range
    @end_date = Time.zone.today
    @start_date = @end_date - 6.days
  end
end
