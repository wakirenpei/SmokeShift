class Smoker::SmokingRecordsController < ApplicationController
  before_action :require_login
  before_action :set_smoking_records, only: [:index, :create]
  before_action :set_statistics, only: [:index, :create]
  before_action :set_smoking_record, only: [:destroy]

  def index
    @new_smoking_record = SmokingRecord.new
    @cigarettes = Cigarette.all
  end

  def create
    @smoking_record = current_user.smoking_records.new(smoking_record_params)

    if @smoking_record.save
      redirect_to smoking_records_path, notice: '喫煙記録が追加されました。'
    else
      render :index
    end
  end

  def destroy
    if @smoking_record.destroy
      redirect_to smoking_records_path, notice: '喫煙記録が削除されました。'
    else
      redirect_to smoking_records_path, alert: '喫煙記録の削除に失敗しました。'
    end
  end

  private

  def set_smoking_records
    @smoking_records = current_user.smoking_records.order(smoked_at: :desc).limit(10)
  end

  def set_statistics
    @total_amount = current_user.smoking_records.sum(:price_per_cigarette)
    @today_amount = current_user.smoking_records.today.sum(:price_per_cigarette)
    @total_count = current_user.smoking_records.count
    @today_count = current_user.smoking_records.today.count
  end

  def set_smoking_record
    @smoking_record = current_user.smoking_records.find(params[:id])
  end

  def smoking_record_params
    params.require(:smoking_record).permit(:cigarette_id)
  end
end
