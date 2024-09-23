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
    @total_savings = calculate_total_savings
  end

  def create
    if current_user.smoking_records.empty?
      redirect_to smoker_smoking_records_path, alert: '喫煙記録がないため、禁煙を開始できません。'
    else
      @quit_smoking_record = current_user.quit_smoking_records.build(start_date: Time.current)
      if @quit_smoking_record.save
        current_user.update(smoking_status: :non_smoker)
        redirect_to non_smoker_quit_smoking_records_path, notice: '禁煙を開始しました。頑張りましょう！'
      else
        redirect_to non_smoker_quit_smoking_records_path, alert: '禁煙の開始に失敗しました。'
      end
    end
  end

  def update
    if @quit_smoking_record.update(end_date: Time.current)
      daily_savings = current_user.calculate_daily_potential_savings
      duration = @quit_smoking_record.duration
      final_savings = (daily_savings * duration / 1.day).round(0)
      
      @quit_smoking_record.update(money_saved: final_savings)
      current_user.update(smoking_status: :smoker)
      redirect_to smoker_smoking_records_path, notice: "禁煙を終了します。お疲れ様でした！"
    else
      redirect_to non_smoker_quit_smoking_records_path, alert: '禁煙記録の更新に失敗しました。'
    end
  end

  def logs
    @quit_smoking_records = current_user.quit_smoking_records.order(start_date: :desc).page(params[:page]).per(10)
    @completed_quit_attempts = @quit_smoking_records.completed
  end

  private

  def set_quit_smoking_record
    @quit_smoking_record = current_user.quit_smoking_records.find(params[:id])
  end

  def calculate_savings(seconds)
    return 0 if @daily_potential_savings.nil?
    (@daily_potential_savings * seconds / 1.day).round(0)
  end

  def calculate_total_quit_seconds
    current_user.quit_smoking_records.sum(&:duration)
  end

  def calculate_total_savings
    completed_savings = current_user.quit_smoking_records.completed.sum(:money_saved)
    current_savings = @current_quit_attempt ? calculate_savings(@current_duration) : 0
    completed_savings + current_savings
  end
end