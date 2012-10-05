class UserMailer < ActionMailer::Base
	include ApplicationHelper

  default :from => Config::Configuration.get(:ssg, :email_address)

  def verification_email(user)
  	@user = user
  	@url = verify_users_url(:id => @user.id, :uuid => @user.uuid)

  	mail(:to => @user.email, :subject => t('users.verify.email_subject'))
  end
end