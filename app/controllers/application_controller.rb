class ApplicationController < ActionController::Base
  include PublicActivity::StoreController
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    if current_user
      redirect_to current_user , alert: "You can't access this page"
    else
      redirect_to root_url, alert: "You can't access this page"
    end
  end

  private
  def current_user
    @current_user ||= User.find_by_auth_token(cookies[:auth_token]) if cookies[:auth_token]
  end
  helper_method :current_user
  hide_action :current_user

  def authorize
    redirect_to login_url, alert: "You must be logged in to continue." if current_user.nil?
  end
end
