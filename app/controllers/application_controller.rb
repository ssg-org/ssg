class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :check_login
  
  
  #TODO
  def check_login
    if (session[:id])
      @user = User.find_by_id(session[:id]) || User.guest_user
    else
      @user = User.guest_user
    end
  end
end
