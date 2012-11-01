class CitiesController < ApplicationController
	def index
		@center_lat = 43.90
		@center_long = 17.70
		@center_zoom = 8
		@categories = @user.get_categories
	end

	def zoom
		@issues = Issue.get_geo_issues(
			{:lat => params[:sw_lat], :long => params[:sw_long]}, 
			{:lat => params[:ne_lat], :long => params[:ne_long]},
			20
		)
		render :json => @issues
	end
end