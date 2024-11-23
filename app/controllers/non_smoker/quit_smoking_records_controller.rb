class NonSmoker::QuitSmokingRecordsController < ApplicationController
  before_action :require_login

  def index
    @current_quit_attempt = current_user.quit_smoking_records.active.first
    @server_time = Time.current.to_i

    return unless @current_quit_attempt

    @current_duration = (@server_time - @current_quit_attempt.start_date.to_i)
    @current_savings = @current_quit_attempt.calculate_savings
  end

  def create
    if smoking_records_empty?
      redirect_to smoker_smoking_records_path, alert: '喫煙記録がないため、禁煙を開始できません。'
    else
      @quit_smoking_record = build_quit_smoking_record
      save_quit_smoking_record
    end
  end

  def update
    @quit_smoking_record = current_user.quit_smoking_records.active.first

    if @quit_smoking_record&.update(end_date: Time.current)
      discontinue_active_goals(@quit_smoking_record)
      update_user_smoking_status(:smoker)
      redirect_to smoker_smoking_records_path, notice: '禁煙を終了します。お疲れ様でした！'
    else
      redirect_to non_smoker_quit_smoking_records_path, alert: '禁煙記録の更新に失敗しました。'
    end
  end

  def logs
    @quit_smoking_records = current_user.quit_smoking_records.order(start_date: :desc).page(params[:page]).per(10)
    @completed_quit_attempts = @quit_smoking_records.completed
  end

  private

  def smoking_records_empty?
    current_user.smoking_records.empty?
  end

  def build_quit_smoking_record
    current_user.quit_smoking_records.build(start_date: Time.current)
  end

  def save_quit_smoking_record
    if @quit_smoking_record.save
      update_user_smoking_status(:non_smoker)
      redirect_to non_smoker_quit_smoking_records_path, notice: '禁煙を開始しました。頑張りましょう！'
    else
      redirect_to non_smoker_quit_smoking_records_path, alert: '禁煙の開始に失敗しました。'
    end
  end

  def update_user_smoking_status(status)
    current_user.update(smoking_status: status)
  end

  def discontinue_active_goals(quit_smoking_record)
    quit_smoking_record.savings_goals.active_goals.each(&:discontinue!)
  end
end
