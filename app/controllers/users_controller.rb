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

  #
  # Login, logout, signup actions
  #
  def signup
    user = User.create_ssg_user(params[:username], params[:email], params[:password1], params[:city_id])
    puts "User #{user.inspect}"

    if user.nil?
      flash[:error] = 'User already exists'
      redirect_to(login_users_path())
    else
      if user.save
        UserMailer.verify(user, "#{request.protocol}#{request.host_with_port}").deliver
        flash[:info] = 'User was sucessfully created. Email has been sent.'
        redirect_to(issues_path())
      else
        flash[:error] = 'Error creating user'
        redirect_to(login_users_path())
      end
      
    end
  end

  def login
    @city_names = collect_city_names()
    @city_names.unshift( [I18n.t('users.login.choose_city'), 0])
  end

  def verify
    user = User.verify(params[:id], params[:uuid])

    if (!user.nil?)
      session[:id] = user.id
      redirect_to(issues_path(), :info => "Thank you")
    else
      redirect_to(login_users_path(), :error => "Error verifying user")
    end
  end

  def activate_password
    forgot_pass = ForgotPassword.where(:token => params[:token]).first

    if forgot_pass.nil?
      flash[:error] = "Pogrešni kredencijali, reset šifre nije dopušten!"
      return redirect_to root_path
    end

    user = forgot_pass.user
    user.password_hash = Digest::SHA256.hexdigest(params[:password1])
    user.save!

    forgot_pass.destroy

    flash[:info] = "Šifra uspješno promjenjena!"
    redirect_to login_users_path()
  end

  def reset_password()
    token = params[:token]
    forgot_pass = ForgotPassword.where(:token => token).first
    if forgot_pass.nil?
      flash[:error] = "Pogrešni kredencijali, reset šifre nije dopušten!"
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

    flash[:info] = "Check your email, instructions on how to reset your password have been sent!"
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
    redirect_to issues_path()
  end
  
  def ssg_login
    user = User.exists?(params[:username], params[:password])
    if user && user.active
      session[:id] = user.id
      redirect_to issues_path()
    else
      flash[:error] = 'Invalid email or password'
      redirect_to login_users_path()
    end
  end

  def ssg_admin_login
    user = User.user_ssg_admin?(params[:username], params[:password])
    if user
      session[:id] = user.id
      redirect_to ssg_admin_path()
    else
      redirect_to(ssg_admin_login_path(), :error => 'Invalid email or password')
    end
  end

  def fb_login

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