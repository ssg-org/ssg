class CommentsController < ApplicationController
	def create
		if !params[:text].blank?
			@user.comment_on_issue(params[:issue_id].to_i, params[:text])
		end
		
		respond_to do |format|
      	format.js
    	end
	end

  def destroy
    comment = Comment.find(params[:id])

    if @user.ssg_admin? || comment.is_owned?(@user)
      comment.destroy
      flash[:info] = 'Uspjesno izbrisan komentar'
    else
      flash[:error] = ApplicationController::ACCESS_DENIED
    end

    return redirect_to request.referer
  end
end