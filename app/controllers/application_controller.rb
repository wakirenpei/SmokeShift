class ApplicationController < ActionController::Base
  before_action :require_login

  private

  def not_authenticated
    redirect_to login_path
  end

  def current_user
    if session[:user_id]
      @current_user = User.find_by(id: session[:user_id])
    end
  end
end
