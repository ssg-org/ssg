class DocumentsController < ApplicationController
	def privacy
	end
	
	def faq
	end

	def contact
	end

	def contact_message
		UserMailer.send_contact_message(params[:question], params[:description], params[:name], params[:email]).deliver
		flash[:info] = t('documents.contact.message_sent')
		redirect_to issues_path()
	end
		
	def terms
	end

	def learn
	end

	def reports
	end
end