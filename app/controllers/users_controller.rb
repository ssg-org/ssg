# encoding: UTF-8
class UsersController < ApplicationController

  def follow
    @user.follow_user(params[:id])
    redirect_to issues_path()
  end

  def index
    @profile_user = User.find(params[:id])
    @issues = Issue.where(:user_id => params[:id]).all
  end

  def edit
    @edit_user = User.find(@user.id)
  end

  def twitter_create
    pp ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    pp request.env["omniauth.auth"]
    pp ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    twitter_info = env["omniauth.auth"]
    t_token      = twitter_info['credentials']['token']
    t_id         = twitter_info['uid']
    f_name       = twitter_info['info']['first_name'] || twitter_info['info']['name']
    l_name       = twitter_info['info']['last_name']
    email        = twitter_info['info']['email']
    username     = twitter_info['info']['nickname']
    
    # check fo user by access_token (fast'n'dirty check)
    user = User.find_by_twitter_token(t_token)

    # not found by token - check by email
    if (user.nil?)
      user = User.find_by_email(email) unless email.nil?
      
      # Not found by email - check FB-id
      if (user.nil?)
        user = User.find_by_twitter_id(t_id)
        
        if (user.nil?)
          user = User.create_twitter_user(t_token, email, t_id, l_name, f_name, username )
        end
      end
    end
      
    session[:id] = user.id

    @redirect_uri = issues_path()
    redirect_to issues_path()
  end

  def twitter_failure
    flash[:error] = "Not able to login to twitter!"
    @redirect_uri = issues_path()
  end

  def settings
    
    # if password there check password
    if !params[:password0].empty? || !(params[:password1].empty? && params[:password2].empty?)
      unless @user.is_good_password?(params[:password0])
        flash[:error] = I18n.t('users.edit.wrong_pass')
        return redirect_to edit_user_path(@user.id)
      end
    end

    # if all good update params
    @user.settings_update(params)
    flash[:info] = I18n.t('users.edit.succ_save')
    redirect_to user_path(@user.id)
  end

  #
  # Login, logout, signup actions
  #
  def signup
    user = User.create_ssg_user(params[:username], params[:email], params[:password1], params[:city_id])
    puts "User #{user.inspect}"

    if user.nil?
      flash[:error] = I18n.t('users.msgs.exists')
      redirect_to(login_users_path())
    else
      if user.save
        UserMailer.verify(user, "#{request.protocol}#{request.host_with_port}").deliver
        flash[:info] = I18n.t('users.msgs.created')
        redirect_to(issues_path())
      else
        flash[:error] = I18n.t('users.msgs.error_create')
        redirect_to(login_users_path())
      end
      
    end
  end

  def login
    # referer url to create issue
    session[:referer_url] = @user.guest? && params[:create_issue] ? new_issue_path() : nil
    
    @city_names = collect_city_names()
    @city_names.unshift( [I18n.t('users.login.choose_city'), ''])
  end

  def verify
    user = User.verify(params[:id], params[:uuid])

    if (!user.nil?)
      session[:id] = user.id
      flash[:info] = I18n.t('users.msgs.thanks')
      redirect_to(issues_path())
    else
      flash[:error] = I18n.t('users.msgs.error_verify')
      redirect_to(login_users_path())
    end
  end

  def activate_password
    forgot_pass = ForgotPassword.where(:token => params[:token]).first

    if forgot_pass.nil?
      flash[:error] = I18n.t('users.msgs.error_creds')
      return redirect_to root_path
    end

    user = forgot_pass.user
    user.password_hash = Digest::SHA256.hexdigest(params[:password1])
    user.save!

    forgot_pass.destroy

    flash[:info] = I18n.t('users.msgs.pass_change')
    redirect_to login_users_path()
  end

  def reset_password()
    token = params[:token]
    forgot_pass = ForgotPassword.where(:token => token).first
    if forgot_pass.nil?
      flash[:error] = I18n.t('users.msgs.error_pass_change')
      return redirect_to root_path()
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

    flash[:info] = I18n.t('users.msgs.forgot_pass')
    redirect_to login_users_path()
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


    redirect_to params[:admin_logout] ? ssg_admin_login_path() : issues_path()
  end
  
  def ssg_login
    user = User.exists?(params[:username], params[:password])
    if user && user.active
      session[:id] = user.id
      redirect_to session[:referer_url] ? session.delete(:referer_url) : issues_path()
    else
      flash[:error] = I18n.t('users.msgs.invalid_login')
      redirect_to login_users_path()
    end
  end

  def ssg_admin_login
    user = User.user_ssg_admin?(params[:username], params[:password])
    if user
      session[:id] = user.id
      redirect_to ssg_admin_path()
    else
      flash[:error] = I18n.t('users.msgs.invalid_login')
      redirect_to(ssg_admin_login_path())
    end
  end

  def fb_login
    require 'pp'
    pp ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    pp env["omniauth.auth"]
    pp ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    fb_info = env["omniauth.auth"]
    fb_token = fb_info['credentials']['token']
    fb_id    = fb_info['uid']
    f_name   = fb_info['info']['first_name']
    l_name   = fb_info['info']['last_name']
    email    = fb_info['info']['email']
    username = fb_info['info']['nickname']

    # check fo user by access_token (fast'n'dirty check)
    user = User.find_by_fb_token(fb_token)

    # not found by token - check by email
    if (user.nil?)
      user = User.find_by_email(email)
      
      # Not found by email - check FB-id
      if (user.nil?)
        user = User.find_by_fb_id(fb_id)
        
        if (user.nil?)
          user = User.create_fb_user(fb_token, email, fb_id, l_name, f_name, username )
        end
        
      end
      
    end
      
    session[:id] = user.id

    @redirect_uri = issues_path()
  end
  
end