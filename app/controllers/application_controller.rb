class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_user, :user_signed_in?, :admin_signed_in?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def user_signed_in?
    !!current_user
  end

  def admin_signed_in?
    session[:admin_signed_in] == true
  end

  def authenticate_user!
    unless user_signed_in?
      redirect_to login_path, alert: "Vous devez être connecté pour accéder à cette page."
    end
  end
end
