class Api::V1::IssuesController < Api::V1::ApiController

  PAGE_SIZE = 10

  #
  # /api/v1/issues?offset=10
  #    
  # offset

  def index
    offset = params[:offset].to_i || 0
    render :api_response => Issue.offset(offset).limit(PAGE_SIZE).all
  end
end