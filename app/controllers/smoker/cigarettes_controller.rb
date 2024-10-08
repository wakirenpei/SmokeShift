class Smoker::CigarettesController < ApplicationController
  before_action :set_cigarette, only: [:edit, :update]

  def index
    @cigarettes = current_user.cigarettes.order(created_at: :desc)
    @cigarette = current_user.cigarettes.build
    @can_add_cigarette = current_user.cigarettes.count < Cigarette::MAX_CIGARETTES_PER_USER
  end

  def create
    @cigarette = current_user.cigarettes.build(cigarette_params)
    if @cigarette.save
      redirect_to smoker_cigarettes_path, notice: 'タバコが正常に登録されました。'
    else
      render turbo_stream: [
        turbo_stream.replace('new_cigarette_form', partial: 'form', locals: { cigarette: @cigarette }),
        turbo_stream.update('error_messages', partial: 'shared/error_messages', locals: { object: @cigarette })
      ], status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @cigarette.update(cigarette_params)
      redirect_to smoker_cigarettes_path, notice: 'タバコ情報が更新されました。'
    else
      flash.now[:alert] = 'タバコ情報の更新に失敗しました。'
      render :edit, status: :unprocessable_entity
    end
  end

  def brands
    @brands = CigaretteBrand.search_by_name(params[:query]).select_brand_details
    render json: @brands
  end

  private

  def set_cigarette
    @cigarette = current_user.cigarettes.find(params[:id])
  end

  def cigarette_params
    params.require(:cigarette).permit(:brand, :quantity_per_pack, :price_per_pack)
  end
end
