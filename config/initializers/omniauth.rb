
Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :facebook, Config::Configuration.get(:fb, :application_id), Config::Configuration.get(:fb, :secret_key), :client_options => {:ssl => {:verify => false }}, :scope => Config::Configuration.get(:fb, :scope), :display => 'popup'
  provider :facebook, Config::Configuration.get(:fb, :application_id), Config::Configuration.get(:fb, :secret_key), :client_options => {:ssl => {:ca_file => '/usr/lib/ssl/certs/ca-certificates.crt'} }, :scope => Config::Configuration.get(:fb, :scope), :display => 'popup'
  #provider :facebook, Config::Configuration.get(:fb, :application_id), Config::Configuration.get(:fb, :secret_key), :scope => Config::Configuration.get(:fb, :scope), :display => 'popup'
end