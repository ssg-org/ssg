Rails.application.config.middleware.use OmniAuth::Builder do

  provider :facebook, Config::Configuration.get(:fb, :application_id), Config::Configuration.get(:fb, :secret_key), :scope => Config::Configuration.get(:fb, :scope), :display => 'popup'

  if Config::Configuration.get(:twitter, :consumer_key).blank? || Config::Configuration.get(:twitter, :consumer_secret).blank?
    warn "*" * 80
    warn "WARNING: Missing consumer key or secret."
    warn "*" * 80
  else
    provider :twitter, Config::Configuration.get(:twitter, :consumer_key), Config::Configuration.get(:twitter, :consumer_secret)
  end
end