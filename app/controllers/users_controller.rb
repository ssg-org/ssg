class UsersController < ApplicationController

  def follow
    @user.follow_user(params[:id])
    redirect_to issues_path()
  end

  #
  # Login, logout, signup actions
  #
  def signup
    user = User.create_ssg_user(params[:username], params[:email], params[:password1], params[:city_id])
    puts "User #{user.inspect}"

    if user.nil?
      redirect_to(login_users_path(), :alert => 'User already exists')
    else
      if user.save
        UserMailer.verify(user).deliver

        redirect_to(issues_path(), :notice => 'User was sucessfully created. Email sent')
      else
        redirect_to(login_users_path(), :alert => 'Error creating user')
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
      redirect_to(issues_path(), :notice => "Thank you")
    else
      redirect_to(login_users_path(), :alert => "Error verifying user")
    end
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
      redirect_to(login_users_path(), :alert => 'Invalid email or password')
    end
  end

  def ssg_admin_login
    user = User.user_ssg_admin?(params[:username], params[:password])
    if user
      session[:id] = user.id
      redirect_to ssg_admin_path()
    else
      redirect_to(ssg_admin_login_path(), :alert => 'Invalid email or password')
    end
  end

  def fb_login
    # Get access token
    puts "*** #{params[:code]}"

    require 'pp'
    pp ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    pp env["omniauth.auth"]
    pp ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

    return issues_path()
    
    if (params[:code])
      fb_client = User.fb_client()
      access_token = fb_client.auth_code.get_token(params[:code], {:redirect_uri => redirect_uri(), :ssl => true})

      require 'ap'
      ap 'works'
      ap access_token
      
      # check fo user by access_token (fast'n'dirty check)
      user = User.find_by_fb_token(access_token.token)

      # not found by token - check by email
      if (user.nil?)
        me = ActiveSupport::JSON.decode(access_token.get('/me'))
        user = User.find_by_email(me['email'])
        
        # Not found by email - check FB-id
        if (user.nil?)
          user = User.find_by_fb_id(me['id'])
          
          if (user.nil?)
            user = User.create_fb_user(access_token.token, me['email'], me['id'], me['last_name'], me['first_name'] )
          end
          
        end
        
      end
      
      session[:id] = user.id
    end
    @redirect_uri = issues_path()
    
  end
  
end