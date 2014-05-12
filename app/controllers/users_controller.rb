# encoding: UTF-8
class UsersController < ApplicationController

  def follow
    @user.follow_user(params[:id])
    redirect_to issues_path()
  end

  def index
    @profile_user = User.find(params[:id])

    if (@profile_user.active)
      @issues = @profile_user.issues.order('created_at desc')
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def edit
    @edit_user = User.find(@user.id)
  end

  def auth_error
    flash[:alert] = "Not able to login to via social network!"
    @redirect_uri = issues_path()
  end

  def settings
    
    # if password there check password
    if !params[:password0].empty? || !(params[:password1].empty? && params[:password2].empty?)
      unless @user.is_good_password?(params[:password0])
        return redirect_to edit_user_path(@user.id), :alert => t('users.edit.wrong_pass')
      end
    end

    # if all good update params
    @user.settings_update(params)

    # Reset local for current session
    if session[:locale] != @user.locale
      I18n.locale = session[:locale] = @user.locale
      Rails.cache.clear
    end

    if session[:script] != @user.script
      I18n.script = session[:script] = @user.script
      Rails.cache.clear
    end

    redirect_to user_path(@user.id), :notice => t('users.edit.succ_save')
  end

  #
  # Login, logout, signup actions
  #
  def signup
    user = User.create_ssg_user(params[:email], params[:password1], params[:city_id], params[:first_name], params[:last_name])

    if user.nil?
      redirect_to login_users_path, :alert => t('users.msgs.exists')
    else
      if user.save
        UserMailer.verify(user, "#{request.protocol}#{request.host_with_port}").deliver

        redirect_to issues_path, :notice => t('users.msgs.created')
      else
        redirect_to login_users_path, :alert => t('users.msgs.error_create')
      end      
    end
  end

  def login

    # Already loged user
    return redirect_to issues_path if !@user.guest?

    # referer url to create issue
    session[:referer_url] = @user.guest? && params[:create_issue] ? new_issue_path() : nil
    
    @city_names = collect_city_names()
    @city_names.unshift( [t('users.login.choose_city'), ''])
  end

  def verify
    user = User.verify(params[:id], params[:uuid])

    if (!user.nil?)
      session[:id] = user.id
      redirect_to issues_path(), :notice => t('users.msgs.verify_ok')
    else
      redirect_to login_users_path(), :alert => t('users.msgs.error_verify')
    end
  end

  def activate_password
    forgot_pass = ForgotPassword.where(:token => params[:token]).first

    if forgot_pass.nil?
      return redirect_to root_path, :alert => t('users.msgs.error_creds')
    end

    user = forgot_pass.user
    user.password_hash = Digest::SHA256.hexdigest(params[:password1])
    user.save!

    forgot_pass.destroy

    flash[:notice] = t('users.msgs.pass_change')

    if (user.ssg_admin?)
      redirect_to ssg_admin_login_path()
    elsif (user.city_admin?)
      redirect_to admin_login_path()
    else
      redirect_to login_users_path()
    end
  end

  def reset_password()
    token = params[:token]
    forgot_pass = ForgotPassword.where(:token => token).first
    if forgot_pass.nil?
      return redirect_to root_path(), :alert => t('users.msgs.error_pass_change')
    end

    @token = forgot_pass.token
  end

  def forgot_password_submit()
    email = params[:email]
    user  = User.where(:email => email).first

    if user
      # check if there is already token with this user
      forgot_pass = ForgotPassword.where(:user_id => user.id).first

      if forgot_pass
        forgot_pass.token = Digest::SHA1.hexdigest(Time.now().to_s + email)
        forgot_pass.save!
      else
        forgot_pass = @user.create_random_reset_password(user)
      end

      UserMailer.reset_password(user, forgot_pass.token, "#{request.protocol}#{request.host_with_port}").deliver
    end

    redirect_to login_users_path(), :notice => t('users.msgs.forgot_pass')
  end

  def redirect_uri()
    uri = URI.parse(request.url)
    uri.path = '/users/fb_login'
    uri.query = nil
    return uri.to_s
  end
  
  def logout
    reset_session
    session = nil

    redirect_to params[:url] ? params[:url] : issues_path()
  end
  
  def ssg_login
    user = User.exists?(params[:email], params[:password])
    if user && user.active
      session[:id] = user.id
      session[:locale] = user.locale
      session[:script] = user.script

      redirect_to session[:referer_url] ? session.delete(:referer_url) : issues_path()
    else
      redirect_to login_users_path(), :alert => t('users.msgs.invalid_login')
    end
  end

  def ssg_admin_login
    user = User.user_ssg_admin?(params[:email], params[:password])
    if user
      session[:id] = user.id
      session[:locale] = user.locale
      session[:script] = user.script

      redirect_to ssg_admin_path()
    else
      redirect_to ssg_admin_login_path(), :alert => t('users.msgs.invalid_login')
    end
  end

def admin_login
    user = User.user_admin?(params[:email], params[:password])
    if user
      session[:id] = user.id
      session[:locale] = user.locale
      session[:script] = user.script
      redirect_to admin_issues_path()
    else
      redirect_to admin_login_path(), :alert => t('users.msgs.invalid_login')
    end
  end

  def fb_login
    fb_info = env["omniauth.auth"]
    fb_token = fb_info['credentials']['token']
    fb_id    = fb_info['uid']
    f_name   = fb_info['info']['first_name']
    l_name   = fb_info['info']['last_name']
    email    = fb_info['info']['email']

    # check fo user by access_token (fast'n'dirty check)
    user = User.find_by_fb_token(fb_token)

    # not found by token - check by email
    if (user.nil?)
      user = User.find_by_email(email)
      
      # Not found by email - check FB-id
      if (user.nil?)
        user = User.find_by_fb_id(fb_id)
        
        if (user.nil?)
          user = User.create_fb_user(fb_token, email, fb_id, l_name, f_name)
        end
        
      end
      
    end
      
    session[:id] = user.id
    session[:locale] = user.locale
    session[:script] = user.script

    @redirect_uri = issues_path()
  end  
end