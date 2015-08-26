class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    
    @current_user ||= User.find_by_id session[:user_id]
  end
  helper_method :current_user
  # adding a `helper_method` call in here makes the method accessible in the
  # view files in addition to the controllers that inherit from this controller

  def user_signed_in?
    current_user.present?
  end
  helper_method :user_signed_in?

end
