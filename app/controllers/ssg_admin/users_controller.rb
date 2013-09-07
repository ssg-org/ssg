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

  def create
  end
end