class UsersController < ApplicationController

  def redirect_uri()
    uri = URI.parse(request.url)
    uri.path = '/users/fb_login'
    uri.query = nil
    return uri.to_s
  end
  
  def index
    @users = User.all
  end
  
  def logout
    reset_session
    session = nil
    redirect_to issues_path()
  end
  
  def fb_login
    # Get access token
    puts "*** #{params[:code]}"
    
    if (params[:code])
      fb_client = User.fb_client()
      access_token = fb_client.web_server.get_access_token(params[:code], {:redirect_uri => redirect_uri(), :ssl => true })
      
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
            # create new user
            user = User.new
            user.email = me['email'] 
            user.fb_id = me['id']
            user.fb_token = access_token.token
            user.last_name = me['last_name']
            user.first_name = me['first_name']
            user.active = true
            user.role = User::ROLE_USER
            user.save
          end
          
        end
        
      end
      
      session[:id] = user.id
    end
    @redirect_uri = issues_url()
    
  end
  
end