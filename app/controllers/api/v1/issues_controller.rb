class Api::V1::IssuesController < Api::V1::ApiController
  def create
    @image = Image.new()
    @image.image = params[:image]
    @image.save!

    image_ids = [ @image.id ]

    @issue = @api_user.create_issue(params[:title], params[:category_id], params[:city_id], params[:description], params[:lat], params[:lng], image_ids)
    
    url = "#{request.protocol}#{request.host_with_port}#{issue_path(@issue.friendly_id)}"

    Thread.new do
      User.send_community_admin_mails(url, issue.city_id)
       # close db connection
      ActiveRecord::Base.connection.close
    end

    render :api_response => { :url => url }

  end
end