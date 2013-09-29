# encoding: UTF-8
class SsgAdmin::CitiesController < SsgAdminController

  def index
    @cities = City.find(:all).sort() { |a,b| a.name <=> b.name}
  end

  def destroy
    City.destroy(params[:id])
    flash[:info] = "Uspješno ste obrisali grad!"
    redirect_to ssg_admin_cities_path()
  end


  # 
  def create_or_edit
    require 'pp'
    pp ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    pp params
    pp ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    is_created = City.create_or_edit(params)

    flash[:info] = "Uspješno ste #{is_created ? 'kreirali' : 'ažurirali'} grad '#{params[:city_name].capitalize}'!"
    redirect_to ssg_admin_cities_path()
  end
end