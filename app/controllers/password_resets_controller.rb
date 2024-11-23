class PasswordResetsController < ApplicationController
  skip_before_action :require_login
  before_action :set_token_user_from_params, only: %i[edit update]
  before_action :check_user_exists, only: %i[edit update]

  def new; end

  def edit; end

  def create
    @user = User.find_by(email: params[:email])

    if @user
      @user.deliver_reset_password_instructions!
      Rails.logger.info "Password reset email sent to: #{params[:email]}"
    else
      Rails.logger.info "Password reset attempted with non-existent email: #{params[:email]}"
    end

    redirect_to login_path, notice: 'パスワードリセットのメールを送信しました'
  end

  def update
    @user.assign_attributes(password_params)

    if @user.save
      redirect_to login_path, notice: 'パスワードがリセットされました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_token_user_from_params
    @token = params[:id]
    @user = User.load_from_reset_password_token(params[:id])
  end

  def check_user_exists
    not_authenticated if @user.blank?
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
