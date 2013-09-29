class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :check_access if Config::Configuration.get(:ssg, :auth_enabled)
  before_filter :check_login

  include ApplicationHelper

  ACCESS_DENIED = "Access DENIED!"

  def self.disable_layout_for_ajax(layout_name = 'application')
    layout Proc.new { |controller| controller.request.xhr? ? nil : layout_name }    
  end

  def change_locale
    session[:locale] = params[:locale]
    redirect_to :back
  end

  private
  def check_login
    # Assing uniq seed for 'view counting'
    if (cookies[:unique].blank?)
      # TODO - DB sequence maybe ? uuid is too space consuming
      cookies[:unique] = Random.new.rand(1..999999999)
    end

    locale = I18n.default_locale

    if (session[:id])
      @user = User.find_by_id(session[:id])
      locale = @user.locale
    else
      # Guest if not from session
      @user = User.guest_user
      # check for session locale
      locale = session[:locale] if session[:locale]
    end

    I18n.locale = locale
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
                                           