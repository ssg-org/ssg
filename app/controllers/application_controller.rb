class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :check_access if Config::Configuration.get(:ssg, :auth_enabled)
  before_filter :check_login

  def self.disable_layout_for_ajax(layout_name = 'application')
    layout Proc.new { |controller| controller.request.xhr? ? nil : layout_name }    
  end

  private
  def check_login
    if (session[:id])
      @user = User.find_by_id(session[:id])
    else
      # Guest if not from session
      @user = User.guest_user
    end
    I18n.locale = @user.locale
  end
  
  private
  def check_access
    puts " #{Config::Configuration.get(:ssg, :auth_enabled).class}"
    authenticate_or_request_with_http_basic do |user_name, password|
      # Change these to username and password required
      user_name == Config::Configuration.get(:ssg, :auth_username) && password == Config::Configuration.get(:ssg, :auth_password)
    end
  end
end
                                           