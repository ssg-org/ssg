class UserMailer < ActionMailer::Base
	include ApplicationHelper

  default :from => Config::Configuration.get(:ssg, :email_address)

  def verify(user)

  	@user = user
  	@url = verify_users_url(:id => @user.id, :uuid => @user.uuid)

	  mail(:to => @user.email, :subject => t('users.verify.email_subject'))
  end

  def reset_password(user, token, url)
    @user = user
    @url = url + reset_password_users_path() + "?token=" + token
    mail(:to => @user.email, :subject => t('users.verify.reset_pass'))
  end

  class Preview < MailView

  	def verify
  		user = User.find(1)
  		mail = UserMailer.verify(user)  		
  	end
  end
end