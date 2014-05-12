class DocumentsController < ApplicationController
	def privacy
	end
	
	def faq
	end

	def contact
	end

	def contact_message
		UserMailer.send_contact_message(params[:question], params[:description], params[:name], params[:email]).deliver

		redirect_to issues_path(), :notice => t('documents.contact.message_sent')
	end
		
	def terms
	end

	def learn
	end

	def reports
	end
end