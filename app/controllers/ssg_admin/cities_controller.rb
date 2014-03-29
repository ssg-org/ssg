# encoding: UTF-8
class SsgAdmin::CitiesController < SsgAdminController

  before_filter :check_ssg_admin

  def index
    @sort_option = sort_option
    @cities = City.order("name #{@sort_option}")
  end

  def destroy
    city = City.find(params[:id])

    num_of_users = city.users.size
    unless num_of_users == 0
      flash[:error] = "Grad ima '#{num_of_users}' aktivnih korisnika. Molimo obišite korisnike prije brisanja grada!"
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

  protected

  def sort_option
    permited_sorts = ["ASC", "DESC"]
    params[:sort].present? && permited_sorts.include?(params[:sort].upcase) ? params[:sort].upcase : "ASC"
  end
end