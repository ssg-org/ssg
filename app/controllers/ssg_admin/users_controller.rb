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
  end

  def new
    @cities = @user.get_cities
  end

  def create
    @user.create_ssg_admin_user(params[:username], params[:email], params[:city_id], params[:first_name], params[:last_name], params[:role], "#{request.protocol}#{request.host_with_port}")
    flash[:info] = "Uspješno ste dodali novog korisnika!"
    redirect_to ssg_admin_users_path
  end


end