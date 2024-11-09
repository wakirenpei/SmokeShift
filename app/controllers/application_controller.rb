class ApplicationController < ActionController::Base
  before_action :require_login
  before_action :set_common_variables, if: :current_user

  private

  def not_authenticated
    redirect_to login_path
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def set_common_variables
    @daily_potential_savings = current_user.quit_smoking_records.active.first&.calculate_savings || 0
    @total_quit_seconds = calculate_total_quit_seconds
    @total_savings = calculate_total_savings
    @total_amount = current_user.smoking_records.total_amount
    @today_amount = current_user.smoking_records.today_amount
    @total_count = current_user.smoking_records.total_count
    @today_count = current_user.smoking_records.today_count
  end

  def calculate_total_quit_seconds
    current_user.quit_smoking_records.sum do |record|
      end_time = record.end_date || Time.current
      end_time.to_i - record.start_date.to_i
    end
  end

  def calculate_total_savings
    current_user.quit_smoking_records.sum(&:calculate_savings)
  end
end