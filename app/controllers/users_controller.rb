class UsersController < ApplicationController


  def follow
    @user.follow_user(params[:id])
    redirect_to issues_path()
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
  
  def login
    @cities = @user.get_cities
  end

  def verify_login
    user = User.exists?(params[:email], params[:password])
    if user && user.active
      session[:id] = user.id
      redirect_to issues_path()
    else
      redirect_to login_users_path()
    end
  end

  def register
    # Check this!!!
    user = User.find_by_email(params[:email])
   
    if (user && user.active == true)
      flash[:error] = 'User already exists'
      redirect_to login_users_path()
    else
      @user = User.register(params[:email], params[:password1])
      flash[:notice] = 'Verification email sent'
      redirect_to login_users_path()
    end
  end

  def fb_login
    # Get access token
    puts "*** #{params[:code]}"
    
    if (params[:code])
      fb_client = User.fb_client()
      access_token = fb_client.web_server.get_access_token(params[:code], {:redirect_uri => redirect_uri(), :ssl => true})
      
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