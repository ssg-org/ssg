# encoding: UTF-8
class SsgAdmin::IssuesController < SsgAdminController

  def index
    # if @user.ssg_admin?
      @issues = Issue.sort_by(params[:sort]).paginate(:page => params[:page], :per_page => 20)
    # elsif @user.
    #   @issues = Issue.where(:city_id => @user.city_id).order('vote_count DESC').all
    # end
  end

  def edit
    @issue = Issue.find(params[:id])
  end


  def update
    issue = Issue.find(params[:id])
    old_status   = issue.status

    # Update model and save
    issue.update_attributes(params[:issue], :without_protection => true)

    # add admin comment
    if old_status != issue.status
      @user.comment_on_issue(issue.id, 'status comment', true, old_status, issue.status)
    end

    # Send  email notifications
    @user.notify_issue_updated(issue)

    flash[:info] = "Uspješno ste ažurirali proble '#{issue.title}'"
    redirect_to ssg_admin_issues_path()
  end

  def destroy
    issue = Issue.find(params[:id])
    issue.destroy

    redirect_to ssg_admin_issues_path()
  end  
end
