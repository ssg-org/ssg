class CitiesController < ApplicationController
	def index
		@center_lat = 43.951822
		@center_long = 17.683984
		@center_zoom = 8
		@categories = @user.get_categories

		@city_names = collect_city_names() unless @city_names
    @city_names.unshift([I18n.t('cities.index.select'), 0])
	end

	def show
		@city = City.find(params[:id])
		@issues = @city.issues
	end

	def zoom
		@issues = Issue.get_geo_issues(
			{:lat => params[:sw_lat], :long => params[:sw_long]}, 
			{:lat => params[:ne_lat], :long => params[:ne_long]},
			20
		)

		# will set members to data we need in map view
		@issues.each  { |issue| issue.setup_json_attributes!() }

		render :json => @issues
	end
end