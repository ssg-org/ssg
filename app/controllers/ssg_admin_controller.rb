class SsgAdminController < ActionController::Base
  protect_from_forgery

  before_filter :check_login, :except => [:login]

  def self.disable_layout_for_ajax(layout_name = 'application')
    layout Proc.new { |controller| controller.request.xhr? ? nil : layout_name }    
  end

  def index
  end

  def login
  end

  private
  def check_login
    if (session[:id])
      @user = User.find_by_id(session[:id])
      return if @user.ssg_admin? || @user.community_admin?
    end
    
    redirect_to ssg_admin_login_path
  end

end