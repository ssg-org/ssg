# encoding: UTF-8
class Admin::CitiesController < AdminController


  def show
    @city = City.find(@user.city_id)
  end

  def edit
    @city = City.find(@user.city_id)
  end

  def update
    @city = City.find(@user.city_id)
    @city.update_attributes(params[:city])

    redirect_to admin_city_path
  end

end