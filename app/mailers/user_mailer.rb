class UserMailer < ActionMailer::Base
	include ApplicationHelper

  default :from => Config::Configuration.get(:ssg, :email_address)

  def verify(user)

  	@user = user
  	@url = verify_users_url(:id => @user.id, :uuid => @user.uuid)

	mail(:to => @user.email, :subject => t('users.verify.email_subject'))
end

  class Preview < MailView

  	def verify
  		user = User.find(1)
  		mail = UserMailer.verify(user)  		
  	end
  end
end