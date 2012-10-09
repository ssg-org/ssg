class ApplicationController < ActionController::Base
  protect_from_forgery
  
  # Only run this filter if in production mode, as don't want to enter password in development
  before_filter :check_access if Rails.env == "production"
  before_filter :check_login
  before_filter :set_locale

  def default_url_options(options={})
    { :locale => I18n.locale }
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def check_login
    if (session[:id])
      @user = User.find_by_id(session[:id])
    end
    # Guest if not from session
    @user ||= User.guest_user
      
    I18n.locale = I18n.default_locale    
  end
  
  def self.disable_layout_for_ajax(layout_name = 'application')
    layout Proc.new { |controller| controller.request.xhr? ? nil : layout_name }    
  end

  private
  def check_access
    authenticate_or_request_with_http_basic do |user_name, password|
      # Change these to username and password required
      user_name == "username" && password == "pass"
    end
  end
end
                                           