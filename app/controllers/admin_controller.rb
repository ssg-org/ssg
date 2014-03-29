class AdminController < ActionController::Base
  protect_from_forgery

  before_filter :check_login, :except => [:login]

  def self.disable_layout_for_ajax(layout_name = 'application')
    layout Proc.new { |controller| controller.request.xhr? ? nil : layout_name }    
  end

  def index
  end

  def login
  end

  protected

  def check_ssg_admin
    return if @user.city_admin?

    redirect_to admin_issues_path
  end

  private

  def check_login
    if (session[:id])
      @user = User.find_by_id(session[:id])
      return if @user.city_admin?
    end
    
    redirect_to admin_login_path
  end

  def current_city
    @user.city
  end

end
