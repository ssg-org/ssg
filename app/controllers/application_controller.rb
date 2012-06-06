class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :check_login
  
  def check_login
    if (session[:id])
      @user = User.find_by_id(session[:id])
    end
    # Guest if not from session
    @user ||= User.guest_user
    
  end
end
