# encoding: UTF-8
class Admin::UpdatesController < AdminController
  before_filter :set_update_and_issue, only: [:edit, :update]

  def edit
  end

  def update
    @update.update_attributes!(update_attributes)

    redirect_to edit_admin_issue_path(@update.issue_id)
  end

  private

  def update_attributes
    params[:update].slice(:subject, :text)
  end

  def set_update_and_issue
    @update = current_city.updates.find(params[:id])
    @issue = @update.issue
  end
end
