class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale

 	def set_locale
 		if (params[:locale].nil? || !I18n.available_locales.include?(params[:locale].to_sym))
  			I18n.locale = I18n.default_locale
  		else
  			I18n.locale = params[:locale]
  		end
	end
end
