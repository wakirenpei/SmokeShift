class NonSmoker::QuitSmokingRecordsController < ApplicationController
  before_action :require_login

  def index
    @current_quit_attempt = current_user.quit_smoking_records.active.first
    @daily_potential_savings = current_user.calculate_daily_potential_savings

    if @current_quit_attempt
      @current_duration = @current_quit_attempt.duration
      @current_savings = @current_quit_attempt.calculate_savings
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
    @quit_smoking_record = current_user.quit_smoking_records.active.first
    if @quit_smoking_record&.update(end_date: Time.current)
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

  def calculate_total_quit_seconds
    current_user.quit_smoking_records.sum(&:duration)
  end

  def calculate_total_savings
    current_user.quit_smoking_records.sum(&:calculate_savings)
  end
end