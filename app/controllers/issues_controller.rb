class IssuesController < ApplicationController
  def index
    @issues = Issue.get_issues(params, 9, 0) 
  end
  
  def new
  end
  
  def create
    @user.create_issue(params[:title], params[:category], params[:city], params[:description], params[:file])
    
    redirect_to issues_path()
  end
  
  def show
    @issue = Issue.find(params[:id])
  end
  
  def vote
    @user.vote_for(params[:id])
    render :json => { :ok => true }
  end
  
  def follow
    @user.follow(params[:id])
    redirect_to issues_path()
  end
end