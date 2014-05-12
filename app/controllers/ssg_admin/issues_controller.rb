# encoding: UTF-8
class SsgAdmin::IssuesController < SsgAdminController

  def index
    @issues = Issue.sort_by(params[:sort]).paginate(:page => params[:page], :per_page => 20)
  end

  def edit
    @issue = Issue.find(params[:id])
  end


  def update
    issue = Issue.find(params[:id])

    # Update model and save
    issue.update_attributes(params[:issue], :without_protection => true)

    # Send  email notifications
    @user.notify_issue_updated(issue)

    redirect_to ssg_admin_issues_path(), :notice => "Uspješno ste ažurirali problem '#{issue.title}'"
  end

  def destroy
    issue = Issue.find(params[:id])
    issue.destroy

    redirect_to ssg_admin_issues_path()
  end  
end
