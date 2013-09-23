class UserMailer < ActionMailer::Base
	include ApplicationHelper

  default :from => Config::Configuration.get(:ssg, :email_address)

  def verify(user, url)

  	@user = user
  	@url = url + verify_users_path() + "?id=#{@user.id}&uuid=#{@user.uuid}"

    #?id=8&uuid=801faacb-979b-44e1-b6eb-eb264699fa15

	  mail(:to => @user.email, :subject => t('users.verify.email_subject'))
  end

  def reset_password(user, token, url)
    @user = user
    @url = url + reset_password_users_path() + "?token=" + token
    mail(:to => @user.email, :subject => t('users.verify.reset_pass'))
  end

  def notify_admin_user_creation(user, token, url)
    @user = user
    @url = url + reset_password_users_path() + "?token=" + token + "&set_pwd=true"
    mail(:to => @user.email, :subject => "Kreiran vam je administarorski nalog na Sredi Svoj Grad")
  end

  class Preview < MailView

  	def verify
  		user = User.find(1)
  		mail = UserMailer.verify(user, '')  		
  	end
  end
end