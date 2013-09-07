
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, Config::Configuration.get(:fb, :application_id), Config::Configuration.get(:fb, :secret_key), :client_options => {:ssl => {:verify => false }}, :scope => Config::Configuration.get(:fb, :scope), :display => 'popup'
end