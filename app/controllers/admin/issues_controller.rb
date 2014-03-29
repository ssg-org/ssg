# encoding: UTF-8
class Admin::IssuesController < AdminController
  include Concerns::ImageUploadHandler
  before_filter :set_issue, only: [:edit, :update]
  layout :layout

  def index
    @issues = Issue.where(:city_id => @user.city_id).order('created_at desc')
  end

  def edit
    @update = Update.new
    @update.user_id = @user.id
    @update.issue_id = @issue
  end

  def update
    @issue.status = params[:status].to_i
    @issue.category_id = params[:category_id]
    @issue.updates << Update.new({ :subject => params[:subject], :text => params[:text], :user_id => @user.id })
    @issue.save!

    @issue.assign_images(image_ids)

    @user.notify_issue_updated @issue

    redirect_to admin_issues_path()
  end

  private

  def layout
    case action_name
    when 'edit' then 'admin/updates'
    else 'admin'
    end
  end

  def set_issue
    @issue = current_city.issues.find_by_id(params[:id])
  end

end
