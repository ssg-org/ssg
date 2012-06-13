class IssuesController < ApplicationController
  def index
    category_id = params[:category]
    
    if (category_id.nil?)
  	  @issues_relation = Issue
	  else
	    @issues_relation = Issue.where(:category_id => category_id)
    end
    
    @issues = @issues_relation.includes([:images, :category]).limit(9).offset(0)
  end
  
  def new
  end
  
  def create
    @user.create_issue(params[:title], params[:category], params[:description], params[:file])
    
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