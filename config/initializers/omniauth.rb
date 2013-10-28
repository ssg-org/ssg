Rails.application.config.middleware.use OmniAuth::Builder do

  if Config::Configuration.get(:fb, :application_id).blank? || Config::Configuration.get(:fb, :secret_key).blank?
    warn "*" * 80
    warn "WARNING: Missing consumer key or secret for facebook."
    warn "*" * 80
  else
    #provider :facebook, Config::Configuration.get(:fb, :application_id), Config::Configuration.get(:fb, :secret_key), :scope => Config::Configuration.get(:fb, :scope), :display => 'popup'
    provider :facebook, Config::Configuration.get(:fb, :application_id), Config::Configuration.get(:fb, :secret_key)
  end

  

  if Config::Configuration.get(:twitter, :consumer_key).blank? || Config::Configuration.get(:twitter, :consumer_secret).blank?
    warn "*" * 80
    warn "WARNING: Missing consumer key or secret for twitter."
    warn "*" * 80
  else
    provider :twitter, Config::Configuration.get(:twitter, :consumer_key), Config::Configuration.get(:twitter, :consumer_secret)
  end
end