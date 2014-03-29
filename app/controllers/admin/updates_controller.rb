# encoding: UTF-8
class Admin::UpdatesController < AdminController

  def edit
    @update = current_city.updates.find(params[:id])
    @issue = @update.issue
  end

  def update
    @update = current_city.updates.find(params[:id])
    @update.update_attributes!(update_attributes)

    redirect_to edit_admin_issue_path(@update.issue_id)
  end

  private

  def update_attributes
    params[:update].slice(:subject, :text)
  end

end
