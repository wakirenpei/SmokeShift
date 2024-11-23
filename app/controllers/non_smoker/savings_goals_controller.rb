class NonSmoker::SavingsGoalsController < ApplicationController
  before_action :require_login
  before_action :set_savings_goal, only: %i[update destroy]
  before_action :ensure_quit_smoking_record, only: [:create]
  before_action :ensure_no_active_goal, only: [:create]
  before_action :set_current_savings, only: %i[index create update]
  before_action :set_active_goal, only: %i[index create update]
  before_action :set_achieved_goals, only: %i[index create update]
  before_action :set_progress_data, only: %i[index create update], if: -> { @active_goal }

  def index
    @savings_goal = current_user.savings_goals.build
  end

  def create
    @savings_goal = current_user.savings_goals.build(savings_goal_params)
    @savings_goal.quit_smoking_record = current_quit_smoking_record

    if @savings_goal.save
      redirect_to non_smoker_savings_goals_path, notice: '貯金目標を設定しました'
    else
      render :index, status: :unprocessable_entity
    end
  end

  def update
    if @savings_goal.update(savings_goal_params)
      redirect_to non_smoker_savings_goals_path, notice: '貯金目標を更新しました'
    else
      @active_goal = @savings_goal
      set_progress_data # @active_goalが変更されたので再設定
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    if @savings_goal.achieved?
      redirect_to non_smoker_savings_goals_path, alert: '達成済みの目標は削除できません'
      return
    end

    @savings_goal.discontinue!
    redirect_to non_smoker_savings_goals_path, notice: '目標を中断しました', status: :see_other
  end

  private

  def set_savings_goal
    @savings_goal = current_user.savings_goals.find(params[:id])
  end

  def savings_goal_params
    params.require(:savings_goal).permit(:target_amount)
  end

  def ensure_quit_smoking_record
    return if current_quit_smoking_record&.active?

    redirect_to new_non_smoker_quit_smoking_record_path, alert: '禁煙記録の作成が必要です'
  end

  def ensure_no_active_goal
    return unless current_user.savings_goals.active_goals.exists?

    redirect_to non_smoker_savings_goals_path, alert: '既に進行中の目標が存在します'
  end

  def set_current_savings
    @current_savings = current_quit_smoking_record&.calculate_savings || 0
  end

  def current_quit_smoking_record
    @current_quit_smoking_record ||= current_user.quit_smoking_records.active.first
  end

  def set_active_goal
    @active_goal = current_user.savings_goals.active_goals.first
    @active_goal&.check_and_update_achievement
  end

  def set_achieved_goals
    @achieved_goals = current_user.savings_goals.achieved_goals
                                  .includes(:quit_smoking_record)
                                  .order(achieved_at: :desc)
                                  .page(params[:page])
                                  .per(5)
  end

  def set_progress_data
    @progress_data = {
      progress_amount: @active_goal.progress_amount,
      remaining_amount: @active_goal.remaining_amount,
      progress_rate: @active_goal.progress_rate,
      estimated_achievement_date: @active_goal.estimated_achievement_date
    }
  end
end
