class ImageController < ApplicationController
	def create
    @image = Image.new(params[:image])
    @image.save!
    respond_to do |format|
      format.js
    end
	end
end