class SavingsGoalsController < ApplicationController
  before_action :require_login
  before_action :set_savings_goal, only: [:edit, :update, :destroy]
  before_action :ensure_quit_smoking_record, only: [:new, :create]
  before_action :ensure_no_active_goal, only: [:new, :create]

  def index
    @active_goal = current_user.savings_goals.active_goals.first
    @achieved_goals = current_user.savings_goals.achieved_goals
      .includes(:quit_smoking_record)
      .order(achieved_at: :desc)
      .page(params[:page])
      .per(5)

    if @active_goal
      @progress_data = {
        progress_amount: @active_goal.progress_amount,
        remaining_amount: @active_goal.remaining_amount,
        progress_rate: @active_goal.progress_rate,
        estimated_achievement_date: @active_goal.estimated_achievement_date
      }
    end
  end

  def new
    @savings_goal = current_user.savings_goals.build
  end

  def create
    @savings_goal = current_user.savings_goals.build(savings_goal_params)
    @savings_goal.quit_smoking_record = current_user.quit_smoking_record

    if @savings_goal.save
      redirect_to savings_goals_path, notice: "貯金目標を設定しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    if @savings_goal.achieved?
      redirect_to savings_goals_path, alert: "達成済みの目標は編集できません"
      return
    end
  end

  def update
    if @savings_goal.achieved?
      redirect_to savings_goals_path, alert: "達成済みの目標は編集できません"
      return
    end

    if @savings_goal.update(savings_goal_params)
      redirect_to savings_goals_path, notice: "貯金目標を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @savings_goal.achieved?
      redirect_to savings_goals_path, alert: "達成済みの目標は削除できません"
      return
    end

    @savings_goal.discontinue!
    redirect_to savings_goals_path, notice: "目標を中断しました", status: :see_other
  end

  private

  def set_savings_goal
    @savings_goal = current_user.savings_goals.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to savings_goals_path, alert: "指定された目標が見つかりませんでした"
  end

  def savings_goal_params
    params.require(:savings_goal).permit(:target_amount)
  end

  def ensure_quit_smoking_record
    unless current_user.quit_smoking_record&.active?
      redirect_to new_quit_smoking_record_path, alert: "禁煙記録の作成が必要です"
    end
  end

  def ensure_no_active_goal
    if current_user.savings_goals.active_goals.exists?
      redirect_to savings_goals_path, alert: "既に進行中の目標が存在します"
    end
  end
end