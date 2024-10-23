class OauthsController < ApplicationController
  skip_before_action :require_login, raise: false

  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]
    if @user = login_from(provider)
      redirect_to root_path, notice: "#{provider.titleize}でログインしました。"
    else
      begin
        @user = create_from(provider) do |user|
          # LINEログインの場合、emailを適切にフォーマット
          if provider == 'line'
            user.email = "line_#{user.email}@example.com"
          end
        end
        reset_session
        auto_login(@user)
        redirect_to root_path, notice: "#{provider.titleize}でアカウントを作成しログインしました。"
      rescue => e
        Rails.logger.error "Login error: #{e.message}"
        redirect_to root_path, alert: "#{provider.titleize}でのログインに失敗しました。"
      end
    end
  end

  private

  def auth_params
    params.permit(:code, :provider, :error, :state)
  end
end