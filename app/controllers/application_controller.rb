class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :user_authorized, :user_logged_in

  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end

  # redirects back to login/registration page if user_id not in session
  def user_authorized
    redirect_to "/" unless session[:user_id]
  end

  # redirects back to scripts page if user_id in session
  def user_logged_in
    redirect_to "/scripts" if session[:user_id]
  end
end
