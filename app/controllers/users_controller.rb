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
    @cities = User.get_cities

    type = params[:type]

    if (type = 'facebook')
      puts "----------- Logging via Facebook"
    elsif (type = 'twitter')
      puts "----------- Logging via Twitter"
    elsif (type = 'ssg')
      puts "----------- Logging via Twitter"
    end
  end

  def sign_up
  end
  
  def verify_login
    user = User.exists?(params[:username], params[:password])
    if user
      session[:id] = user.id
      redirect_to issues_path()
    else
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