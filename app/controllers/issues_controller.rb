# encoding: UTF-8
class IssuesController < ApplicationController
  
  disable_layout_for_ajax
  
  def index
    params[:offset] ||= 0
    @issues = Issue.get_issues(params, 12, params[:offset].to_i)
    @city_names = collect_city_names() unless @city_names
    @city_names.unshift([t('issues.right_menu.all_counties'), 0])
  end
  
  def more
    index
  end
  
  def new
    @issue = Issue.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @issue }
    end
  end
  
  def create
    image_count = params[:image_count].to_i
    image_ids = []
    (0..image_count-1).each do |i|
      image_ids << params["image_#{i}"]
    end

    flash[:info] = t('issues.new.success')
    issue = @user.create_issue(params[:issue][:title], params[:issue][:category_id], params[:issue][:city_id], params[:issue][:description], params[:issue][:lat], params[:issue][:long],image_ids)
    
    url = "#{request.protocol}#{request.host_with_port}#{issue_path(issue.friendly_id)}"

    Thread.new do
      User.send_community_admin_mails(url, issue.city_id)
       # close db connection
      ActiveRecord::Base.connection.close
    end

    redirect_to issues_path()
  end
  
  def attach_images
    image_id = params["image_0"]

    Image.update_all({ :issue_id => params[:id] }, { :id => image_id })

    redirect_to issue_url(params[:id])
  end

  def show
    ActiveRecord::Base.transaction do
      @issue = Issue.find(params[:id])
      # Can't update View Count if this is your issue
      # TODO Refactor this
      @issue.mark_as_viewed(cookies[:unique])

      @already_voted = !(@issue.votes.where(:user_id => @user.id).first.nil?)
    end
  end

  def destroy
    issue = Issue.find(params[:id])

    if @user.id == issue.user_id || @user.ssg_admin?
      issue.status = Issue::DELETED
      issue.save!
      flash[:info] = t('issues.delete.success')
    else
      flash[:error] = t('issues.delete.error')
    end

    redirect_to issues_url()
  end
  
  def vote
    @user.vote_for(params[:id])
    render :json => { :ok => true }
  end

  def change_status
    @user.change_status_for(params[:id], params[:status])
    render :json => { :ok => true }
  end

  def unvote
    @user.unvote_for(params[:id])
    render :json => { :ok => true }
  end

  def follow
    @user.follow(params[:id])
    redirect_to issues_path()
  end
end