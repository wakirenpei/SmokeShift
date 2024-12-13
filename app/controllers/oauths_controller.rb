class OauthsController < ApplicationController
  skip_before_action :require_login, raise: false

  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]
    if (@user = login_from(provider))
      handle_existing_user_login(provider)
    else
      handle_new_user_creation(provider)
    end
  rescue StandardError => e
    Rails.logger.error "LINEログインエラー: Provider=#{provider}, Params=#{auth_params}, Error=#{e.message}"
    redirect_to root_path, alert: "LINEログインに失敗しました。もう一度お試しください。"
  end

  private

  def auth_params
    params.permit(:code, :provider, :error, :state)
  end

  def handle_existing_user_login(provider)
    redirect_to root_path, notice: "#{provider.titleize}でログインしました。"
  end

  def handle_new_user_creation(provider)
    @user = create_user_from_provider(provider)
    if @user
      reset_session
      auto_login(@user)
      redirect_to smoker_smoking_records_path, notice: "#{provider.titleize}でアカウントを作成しログインしました。"
    else
      log_and_redirect_error("新規登録失敗", provider)
    end
  end

  def create_user_from_provider(provider)
    create_from(provider)
  rescue StandardError => e
    Rails.logger.error "新規登録エラー: Provider=#{provider}, Error=#{e.message}"
    nil # リダイレクト処理は呼び出し元に任せる
  end

  def log_and_redirect_error(message, provider)
    Rails.logger.error "#{message}: Provider=#{provider}, Params=#{auth_params}"
    redirect_to root_path, alert: "#{provider.titleize}でのログインに失敗しました。"
  end
end
