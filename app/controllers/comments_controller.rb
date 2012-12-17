class CommentsController < ApplicationController
	def create
		if !params[:text].blank?
			@user.comment_on_issue(params[:issue_id].to_i, params[:text])
		end
		
		respond_to do |format|
      	format.js
    	end
	end
end