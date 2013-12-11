# encoding: UTF-8
class SsgAdmin::UsersController < SsgAdminController

  before_filter :check_ssg_admin
  
  def index
    @users = User.find(:all)
  end

  def destroy
    user = User.find(params[:id])

    if user.issues.size > 0
      flash[:error] = "Korisnik ima kreirane probleme, prvo pobrišite probleme."
    else
      user.delete!
      flash[:info] = "Uspješno ste obrisali korisnika!"
    end

    redirect_to ssg_admin_users_path()
  end

  def update
    @user.ssg_admin_update(params)
    flash[:info] = "Uspješno ste ažurirali korisnika!"
    redirect_to ssg_admin_users_path
  end

  def new
    @cities = @user.get_cities
  end

  def edit
    @edit_user = User.find(params[:id])
  end

  def create
    @user.create_ssg_admin_user(params[:email], params[:city_id], params[:first_name], params[:last_name], params[:role], "#{request.protocol}#{request.host_with_port}")
    flash[:info] = "Uspješno ste dodali novog korisnika!"
    redirect_to ssg_admin_users_path
  end
end