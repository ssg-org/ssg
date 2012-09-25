class CommentsController < ApplicationController
	def create
		@user.comment_on_issue(params[:issue_id].to_i, params[:text])
		
		respond_to do |format|
      	format.js
    	end
	end
end