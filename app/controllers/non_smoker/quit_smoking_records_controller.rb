class NonSmoker::QuitSmokingRecordsController < ApplicationController
  before_action :require_login
  before_action :set_quit_smoking_record, only: [:update]

  def index
    # 現在進行中の禁煙試行を取得
    @current_quit_attempt = current_user.quit_smoking_records.active.first
    # すべての禁煙記録を日付順に取得
    @quit_smoking_records = current_user.quit_smoking_records.order(start_date: :desc)
    # 1日あたりの潜在的な節約額を計算
    @daily_potential_savings = current_user.calculate_daily_potential_savings
    # 総禁煙日数を計算
    @total_quit_days = calculate_total_quit_days
    # 総節約額を計算
    @total_savings = calculate_total_savings
  end

  def create
    ActiveRecord::Base.transaction do
      @quit_smoking_record = current_user.quit_smoking_records.build(start_date: Date.today)
      @quit_smoking_record.save!
      update_user_status(:non_smoker)
    end
    redirect_to quit_smoking_records_path, notice: '禁煙を開始しました。頑張りましょう！'
  rescue ActiveRecord::RecordInvalid
    redirect_back(fallback_location: smoker_smoking_records_path, alert: '禁煙の開始に失敗しました。')
  end

  def update
    ActiveRecord::Base.transaction do
      @quit_smoking_record.update!(end_date: Date.today)
      update_user_status(:smoker)
    end
    redirect_to quit_smoking_records_path, notice: '禁煙記録を更新しました。次の挑戦に向けて準備しましょう。'
  rescue ActiveRecord::RecordInvalid
    redirect_back(fallback_location: smoker_quit_smoking_records_path, alert: '禁煙の開始に失敗しました。')
  end

  private

  # 特定の禁煙記録を取得するメソッド
  def set_quit_smoking_record
    @quit_smoking_record = current_user.quit_smoking_records.find(params[:id])
  end

  # ユーザーの喫煙状態を更新するメソッド
  def update_user_status(status)
    current_user.update!(smoking_status: status)
  end

  # 総禁煙日数を計算するメソッド
  def calculate_total_quit_days
    current_user.quit_smoking_records.sum do |record|
      (record.end_date || Date.today) - record.start_date
    end.to_i
  end

  # 総節約額を計算するメソッド
  def calculate_total_savings
    current_user.quit_smoking_records.sum do |record|
      days = ((record.end_date || Date.today) - record.start_date).to_i
      days * @daily_potential_savings
    end
  end
end