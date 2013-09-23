# encoding: UTF-8
class SsgAdmin::UsersController < SsgAdminController

  def index
    @users = User.find(:all)
    require 'pp'
    pp ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    pp @users.first
    pp ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  end

  def destroy
    user = User.find(params[:id])

    if user.issues.size > 0
      flash[:error] = "Korisnik ima kreirane probleme, prvo pobrišite probleme."
    else
      user.destroy
      flash[:info] = "Uspješno ste obrisali korisnika!"
    end

    redirect_to ssg_admin_users_path()
  end

  def create
  end
end