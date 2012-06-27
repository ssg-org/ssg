class WelcomeController < ApplicationController
  def index
  end

  def subscribe
  	email = params[:email]

  	logger.info "***********************************************"

  	if (!email.nil?)  		
  		invite = Invite.find_by_email(email)

  		if (invite.nil?)
  			invite = Invite.new
  			invite.email = email
  			invite.save

  			flash[:subscribed] = true
  		end  		
  	end
  	logger.info "***********************************************"

  	redirect_to root_path(:locale => I18n.locale)
  end
end 