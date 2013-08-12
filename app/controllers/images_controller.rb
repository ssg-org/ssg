class ImagesController < ApplicationController
	def create
    require 'pp'
    pp ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    pp params
    pp ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    @image = Image.new()
    @image.image = params[:image]
    @image.save!
    
    respond_to do |format|
      format.js
    end
	end
end