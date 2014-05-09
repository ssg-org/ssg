class CitiesController < ApplicationController
	def index
		@center_lat = 43.951822
		@center_long = 17.683984
		@center_zoom = 8
		@categories = @user.get_categories

		@cities = @user.get_cities
	end

	def show
		@city = City.find(params[:id])
		@issues = @city.issues.includes([:images, :user, :category, :city]).order('created_at desc')
	end

	def zoom
		# Limit removed
		@issues = Issue.get_geo_issues(
			{:lat => params[:sw_lat], :long => params[:sw_long]}, 
			{:lat => params[:ne_lat], :long => params[:ne_long]}
			#,20
		)

		# will set members to data we need in map view
		@issues.each  { |issue| issue.setup_json_attributes!() }

		render :json => @issues
	end
end