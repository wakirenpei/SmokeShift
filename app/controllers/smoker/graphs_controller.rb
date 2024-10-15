class Smoker::GraphsController < ApplicationController
  before_action :require_login
  before_action :set_date_range

  def index
    @period = params[:period] || 'daily'
    @daily_smoking_data = SmokingRecord.fetch_data(current_user, :day, @start_date, @end_date)
    @weekly_smoking_data = SmokingRecord.fetch_data(current_user, :week, @start_date, @end_date)
    @monthly_smoking_data = SmokingRecord.fetch_data(current_user, :month, @start_date, @end_date)
    @hourly_smoking_data = SmokingRecord.fetch_hourly_data(current_user)
  end

  private

  def set_date_range
    @end_date = Date.today
    @start_date = @end_date - 6.days
  end
end
