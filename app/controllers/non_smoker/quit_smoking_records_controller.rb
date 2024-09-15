class NonSmoker::QuitSmokingRecordsController < ApplicationController
  before_action :require_login
  before_action :set_quit_smoking_record, only: [:update]

  def index
    @current_quit_attempt = current_user.quit_smoking_records.active.first
    @daily_potential_savings = current_user.calculate_daily_potential_savings
    
    if @current_quit_attempt
      @current_duration = @current_quit_attempt.duration
      @current_savings = calculate_savings(@current_duration)
    end
    
    @total_quit_seconds = calculate_total_quit_seconds
    @total_savings = calculate_savings(@total_quit_seconds)
  end

  def create
    @quit_smoking_record = current_user.quit_smoking_records.build(start_date: Time.current)
    if @quit_smoking_record.save
      current_user.update(smoking_status: :non_smoker)
      redirect_to non_smoker_quit_smoking_records_path, notice: '禁煙を開始しました。頑張りましょう！'
    else
      redirect_to non_smoker_quit_smoking_records_path, alert: '禁煙の開始に失敗しました。'
    end
  end

  def update
    if @quit_smoking_record.update(end_date: Time.current)
      current_user.update(smoking_status: :smoker)
      redirect_to non_smoker_quit_smoking_records_path, notice: '禁煙記録を更新しました。次の挑戦に向けて準備しましょう。'
    else
      redirect_to non_smoker_quit_smoking_records_path, alert: '禁煙記録の更新に失敗しました。'
    end
  end

  private

  def set_quit_smoking_record
    @quit_smoking_record = current_user.quit_smoking_records.find(params[:id])
  end

  def calculate_savings(seconds)
    (@daily_potential_savings * seconds / 86400.0).round(0)
  end

  def calculate_total_quit_seconds
    current_user.quit_smoking_records.sum(&:duration)
  end
end
