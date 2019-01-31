class ApplicationController < ActionController::Base
  helper_method :current_user

  def require_user
    unless current_user.present?
      flash[:errors] = "You need to login first."

      return redirect_to root_path
    end
  end

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
