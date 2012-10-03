class UserMailer < ActionMailer::Base
  default :from => "noreply@sredisvojgrad.com"

  def confirm_email (user)
  	@user = user
  	@url = "www.sredisvojgrad.com/users/verify?uuid=" + user.uuid

  	mail(:to => user.email, :subject => '[SSG] Please verify your email')
  end
end