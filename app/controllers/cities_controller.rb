class CitiesController < ApplicationController
	def index
		@cities = @user.get_cities
		@issues = Issue.order('created_at desc').limit(100);
	end
end