class Smoker::CigarettesController < ApplicationController
  before_action :set_cigarette, only: [:edit, :update, :destroy]

  def index
    @cigarettes = current_user.cigarettes.order(created_at: :desc)
    @new_cigarette = current_user.cigarettes.build
  end

  def create
    @cigarette = current_user.cigarettes.build(cigarette_params)
    if @cigarette.save
      redirect_to smoker_cigarettes_path, notice: 'タバコが正常に登録されました。'
    else
      @cigarettes = current_user.cigarettes.order(created_at: :desc)
      flash.now[:alert] = 'タバコの登録に失敗しました。'
      render :index
    end
  end

  def edit
  end

  def update
    if @cigarette.update(cigarette_params)
      redirect_to smoker_cigarettes_path, notice: 'タバコ情報が更新されました。'
    else
      flash.now[:alert] = 'タバコ情報の更新に失敗しました。'
      render :edit
    end
  end

  def destroy
    @cigarette.destroy!
    redirect_to smoker_cigarettes_path, notice: 'タバコ情報が削除されました。'
  end

  private

  def set_cigarette
    @cigarette = current_user.cigarettes.find(params[:id])
  end

  def cigarette_params
    params.require(:cigarette).permit(:brand, :quantity_per_pack, :price_per_pack)
  end
end
