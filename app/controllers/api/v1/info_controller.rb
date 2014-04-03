class Api::V1::InfoController < Api::V1::ApiController
	def index
		@cities = City.all
		@categories = Category.all

		render :api_response => { 
			:cities => @cities,
			:categories => @categories
		}
	end
end