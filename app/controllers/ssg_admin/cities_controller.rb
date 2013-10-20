# encoding: UTF-8
class SsgAdmin::CitiesController < SsgAdminController

  before_filter :check_ssg_admin

  def index
    @cities = City.find(:all).sort() { |a,b| a.name <=> b.name}
  end

  def destroy
    city = City.find(params[:id])

    num_of_users = city.users.size
    unless num_of_users == 0
      flash[:error] = "Opština ima '#{num_of_users}' korisnika vezanih za sebe ne možemo obrisati opštinu!"
    else
      city.delete!
      flash[:info] = "Uspješno ste obrisali grad!"
    end
    redirect_to ssg_admin_cities_path()
  end


  # 
  def create_or_edit
    is_created = City.create_or_edit(params)

    flash[:info] = "Uspješno ste #{is_created ? 'kreirali' : 'ažurirali'} grad '#{params[:city_name].capitalize}'!"
    redirect_to ssg_admin_cities_path()
  end
end