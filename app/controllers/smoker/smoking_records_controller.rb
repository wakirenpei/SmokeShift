class Smoker::SmokingRecordsController < ApplicationController
  before_action :require_login
  before_action :set_common_data, only: [:index, :create]

  def index
    @new_smoking_record = SmokingRecord.new
    @start_date = params[:start_date] ? Date.parse(params[:start_date]) : Date.today.beginning_of_month
    @end_date = @start_date.end_of_month
    @calendar_records = current_user.smoking_records.where(smoked_at: @start_date.beginning_of_month.beginning_of_day..@end_date.end_of_day)
    @paginated_records = current_user.smoking_records.today.order(smoked_at: :desc).page(params[:page]).per(10)
  end

  def create
    if current_user.currently_quitting?
      redirect_to smoker_smoking_records_path, alert: '禁煙中は喫煙記録を追加できません。禁煙を終了してから記録してください。'
    else
      @new_smoking_record = current_user.smoking_records.build(smoking_record_params)
      if @new_smoking_record.save
        redirect_to smoker_smoking_records_path, notice: '喫煙記録が追加されました。'
      else
        set_common_data
        flash.now[:alert] = '喫煙記録の追加に失敗しました。'
        render :index, status: :unprocessable_entity
      end
    end
  end

  def destroy
    @smoking_record = current_user.smoking_records.find(params[:id])
    @smoking_record.destroy!
    redirect_to smoker_smoking_records_path, notice: '喫煙記録が削除されました。'
  end

  private

  # 共通データの設定
  def set_common_data
    @cigarettes = current_user.cigarettes
    set_statistics
  end

  # 統計情報の設定
  def set_statistics
    @total_amount = current_user.smoking_records.total_amount
    @today_amount = current_user.smoking_records.today_amount
    @total_count = current_user.smoking_records.total_count
    @today_count = current_user.smoking_records.today_count
  end

  # 喫煙記録のパラメータ設定
  def smoking_record_params
    params.require(:smoking_record).permit(:cigarette_id)
  end
end
