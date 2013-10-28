# encoding: UTF-8
class SsgAdmin::IssuesController < SsgAdminController

  def index

    if @user.ssg_admin?
      @issues = Issue.find(:all, :order => 'vote_count DESC')
    else
      @issues = Issue.where(:city_id => @user.city_id).order('vote_count DESC').all
    end
  end

  def edit
    @issue = Issue.find(params[:id])
  end


  def update

    issue = Issue.find(params[:id])

    issue.title = params[:issue][:title]
    issue.city_id = params[:issue][:city_id].to_i
    issue.category_id = params[:issue][:category_id].to_i
    old_status   = issue.status
    issue.status = params[:issue][:status].to_i
    issue.description = params[:issue][:description]

    issue.save

    # add admin comment
    if old_status != issue.status
      @user.comment_on_issue(issue.id, 'status comment', true, old_status, issue.status)
    end

    flash[:info] = "Uspješno ste ažurirali proble '#{issue.title}'"
    redirect_to ssg_admin_issues_path()
  end

  def destroy
  end
  
end