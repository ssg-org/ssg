class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :check_login
  
  def check_login
   if (session[:id])
      @user = User.find_by_id(session[:id])
   end
    # Guest if not from session
    @user ||= User.guest_user
    
    I18n.locale = 'en'# || I18n.default_locale  
    
  end
  
  def self.disable_layout_for_ajax(layout_name = 'application')
    layout Proc.new { |controller| controller.request.xhr? ? nil : layout_name }    
  end
  
 
  
end
                                           