# encoding: UTF-8
class Admin::IssuesController < AdminController

  def index
    @issues = Issue.where(:city_id => @user.city_id).order('created_at desc')
  end

  def edit
    @issue = Issue.where(:city_id => @user.city_id, :id => params[:id]).first
    @update = Update.new
    @update.user_id = @user.id
    @update.issue_id = @issue
  end

  def update
    @issue = Issue.where(:city_id => @user.city_id, :id => params[:id]).first
    @issue.status = params[:status].to_i
    @issue.category_id = params[:category_id]
    @issue.updates << Update.new({ :subject => params[:subject], :text => params[:text], :user_id => @user.id })
    @issue.save!

    image_count = params[:image_count].to_i
    image_ids = []
    (0..image_count-1).each do |i|
      image_ids << params["image_#{i}"]
    end
    Image.update_all({ :issue_id => @issue.id}, { :id => image_ids })

    @user.notify_issue_updated @issue

    redirect_to admin_issues_path()
  end

end
