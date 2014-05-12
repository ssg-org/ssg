ActionMailer::Base.add_delivery_method :ses, 
	AWS::SES::Base,
    :access_key_id     	=> Config::Configuration.get(:aws, :access_key),
    :secret_access_key 	=> Config::Configuration.get(:aws, :access_secret),
    :server	       			=> Config::Configuration.get(:aws, :ses_region)
