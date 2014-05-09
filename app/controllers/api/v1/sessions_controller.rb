require 'securerandom'

class Api::V1::SessionsController < Api::V1::ApiController

  # POST /api/v1/sessions
  # Params:
  #   email
  #   password
  #   ts
  #   signature
  # Response: 
  #
  #  { 'access_token' => '123123-123123-123-123-123-123' }
  #
  # Errors:
  #  { code : 600, msg : 'Invalid credentials' }
  #
  #  { code : 400, msg : 'Bad request')
  #  { code : 600, msg : 'Invalid credentials')
  #  { code : 601, msg : "Missing required param : #{name}")
  #  { code : 602, msg : "Invalid signature")
  #  { code : 603, msg : "Timestamp too old")
  #
  def create
    define_required(:ts, :signature, :email, :password)

    usr = User.exists?(params[:email], params[:password])
    if (!usr.nil? && usr.active) 
      usr.access_token = SecureRandom.uuid 
      usr.save!

      render :api_response => { 
        :access_token => usr.access_token, 
        :user => usr,
        :avatar_path => usr.avatar        
      }
    else
      raise Api::V1::ApiError.invalid_user
    end
  end


  # POST /api/v1/sessions/fb_create
  # Params:
  #   email
  #   fb_id
  #   first_name
  #   last_name
  #   ts
  #   signature
  # Response: 
  #
  #  { 'access_token' => '123123-123123-123-123-123-123' }
  #
  # Errors:
  #  { code : 600, msg : 'Invalid credentials' }
  #
  #  { code : 400, msg : 'Bad request')
  #  { code : 600, msg : 'Invalid credentials')
  #  { code : 601, msg : "Missing required param : #{name}")
  #  { code : 602, msg : "Invalid signature")
  #  { code : 603, msg : "Timestamp too old")
  #
  def fb_create
    define_required(:ts, :signature, :email, :fb_id, :first_name, :last_name)

    @user = User.where(:email => params[:email]).first
    if (@user.nil?)
      # create new user
      @user = User.create({ 
        :email => params[:email], 
        :uuid => UUIDTools::UUID.random_create.to_s, 
        :active => true, 
        :role => User::ROLE_USER, 
        :locale => :bs,
        :first_name => params[:first_name],
        :last_name => params[:last_name],
        :fb_id => params[:fb_id],
        :access_token => SecureRandom.uuid 
      })
    else
      # user have fb_id equal
      if @user.fb_id.to_s == params[:fb_id]
        @user.fb_token = params[:fb_token]
        @user.access_token = SecureRandom.uuid if @user.access_token.empty?
        @user.save!
      else
        # user doesn't have fb_id or it's different
        # @user.fb_id = params[]
      end
    end

    if (!@user.nil?)
      render :api_response => { 
        :access_token => @user.access_token,
        :user => @user,
        :avatar_path => @user.avatar
      }
    else
      raise Api::V1::ApiError.invalid_user
    end
  end

  # POST /api/v1/sessions/fb_create
  # Params:
  #   email
  #   password
  #   city_id
  #   first_name
  #   last_name
  #   ts
  #   signature
  # Response: 
  #
  #  { 'access_token' => '123123-123123-123-123-123-123' }
  #
  # Errors:
  #  { code : 604, msg :  "User already exist"}
  #  { code : 605, msg :  "Error creating user"}
  #
  #  { code : 400, msg : 'Bad request')
  #  { code : 600, msg : 'Invalid credentials')
  #  { code : 601, msg : "Missing required param : #{name}")
  #  { code : 602, msg : "Invalid signature")
  #  { code : 603, msg : "Timestamp too old")
  def signup
    # define_required(:ts, :signature, :email, :password, :city_id,  :first_name, :last_name)
    define_required(:email, :password, :city_id,  :first_name, :last_name)

    user = User.create_ssg_user(params[:email], params[:password], params[:city_id], params[:first_name], params[:last_name])

    if user.nil?
      raise Api::V1::ApiError.invalid_user
    else
      if user.save
        UserMailer.verify(user, "#{request.protocol}#{request.host_with_port}").deliver
        render :api_response => { :verify => 'Verify email' }
      else
        raise Api::V1::ApiError.error_creating_exist
      end      
    end
  end

end