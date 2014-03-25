require 'securerandom'

class Api::V1::SessionsController < Api::V1::ApiController

  # POST /api/v1/sessions?email=asd@asd.com&password=asdasd
  # Response: { 'access_token' => '123123-123123-123-123-123-123' }
  #
  def create
    define_required(:email, :password)

    usr = User.exists?(params[:email], params[:password])
    if (!usr.nil?) 
      usr.access_token = SecureRandom.uuid 
      usr.save!

      render :api_response => { :access_token => usr.access_token }
    else
      raise Api::V1::ApiError.invalid_user
    end
  end
end