class Smoker::SmokingRecordsController < ApplicationController
  before_action :require_login
  before_action :set_smoking_record, only: [:destroy]
  before_action :set_common_data, only: [:index, :create]

  def index
    @new_smoking_record = SmokingRecord.new
    @smoking_records = current_user.smoking_records.today.order(smoked_at: :desc).page(params[:page]).per(10)
  end

  def create
    if current_user.currently_quitting?
      redirect_to smoker_smoking_records_path, alert: '禁煙中は喫煙記録を追加できません。禁煙を終了してから記録してください。'
    else
      @smoking_record = current_user.smoking_records.build(smoking_record_params)
      if @smoking_record.save
        redirect_to smoker_smoking_records_path, notice: '喫煙記録が追加されました。'
      else
        @new_smoking_record = @smoking_record
        @smoking_records = current_user.smoking_records.today.order(smoked_at: :desc).page(params[:page]).per(10)
        render :index, status: :unprocessable_entity
      end
    end
  end

  def destroy
    if @smoking_record.destroy
      redirect_to smoker_smoking_records_path, notice: '喫煙記録が削除されました。'
    else
      redirect_to smoker_smoking_records_path, alert: '喫煙記録の削除に失敗しました。'
    end
  end

  private

  def set_common_data
    @smoking_records = current_user.smoking_records.order(smoked_at: :desc).limit(10)
    @cigarettes = current_user.cigarettes
    set_statistics
    set_calendar_data
  end

  def set_statistics
    @total_amount = current_user.smoking_records.total_amount
    @today_amount = current_user.smoking_records.today_amount
    @total_count = current_user.smoking_records.total_count
    @today_count = current_user.smoking_records.today_count
  end

  def set_smoking_record
    @smoking_record = current_user.smoking_records.find(params[:id])
  end

  def set_calendar_data
    @start_date = params[:start_date] ? Date.parse(params[:start_date]) : Date.today.beginning_of_month
    @end_date = @start_date.end_of_month

    @calendar_data = current_user.smoking_records
      .where(smoked_at: @start_date..@end_date)
      .group_by { |record| record.smoked_at.to_date }
      .transform_values do |records|
        {
          count: records.count,
          amount: records.sum(&:price_per_cigarette)
        }
      end
  end

  def smoking_record_params
    params.require(:smoking_record).permit(:cigarette_id)
  end
end