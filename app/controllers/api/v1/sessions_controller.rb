require 'securerandom'

class Api::V1::SessionsController < Api::V1::ApiController

  # POST /api/v1/sessions
  # Params:
  #   email
  #   password
  #   ts
  #   signature
  # Response: 
  #  { 'access_token' => '123123-123123-123-123-123-123' }
  def create
    define_required(:ts, :signature, :email, :password)

    usr = User.exists?(params[:email], params[:password])
    if (!usr.nil?) 
      usr.access_token = SecureRandom.uuid 
      usr.save!

      render :api_response => { :access_token => usr.access_token }
    else
      raise Api::V1::ApiError.invalid_user
    end
  end


  # POST /api/v1/sessions/fb_create
  # Params:
  #   email
  #   fb_id
  #   firstname
  #   lastname
  #   ts
  #   signature
  # Response: 
  #  { 'access_token' => '123123-123123-123-123-123-123' }
  def fb_create
    define_required(:ts, :signature, :email, :fb_id, :firstname, :lastname)

    @user = User.where(:email => params[:email]).first
    if (@user.nil?)
      # create new user
      @user = User.create({ 
        :email => params[:email], 
        :uuid => UUIDTools::UUID.random_create.to_s, 
        :active => true, 
        :role => User::ROLE_USER, 
        :locale => :bs,
        :first_name => params[:firstname],
        :last_name => params[:lastname],
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
      render :api_response => { :access_token => @user.access_token }
    else
      raise Api::V1::ApiError.invalid_user
    end
  end

end