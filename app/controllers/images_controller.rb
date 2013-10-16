class ImagesController < ApplicationController
  def create
    @image = Image.new()
    @image.image = params[:image]
    @image.save!
    
    respond_to do |format|
      format.js
    end
  end

  def destroy
    image = Image.find(params[:id])
    city_id = image.issue.city.id

    if @user.ssg_admin? || (@user.community_admin? && city_id == @user.city.id)
      image.destroy
    end

    redirect_to :back
  end

end