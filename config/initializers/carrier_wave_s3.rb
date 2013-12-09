
CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',                        # required
    :aws_access_key_id      => Config::Configuration.get(:aws, :access_key),
    :aws_secret_access_key  => Config::Configuration.get(:aws, :access_secret),
    :region                 => 'eu-west-1'                  # optional, defaults to 'us-east-1'
    #:host                   => 's3.example.com',             # optional, defaults to nil
    #:endpoint               => 'https://s3.example.com:8080' # optional, defaults to nil
  }
  config.fog_directory  = 'ssg-dev'                               # required
  config.fog_public     = false                                   # optional, defaults to true
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
  
  #config.asset_host = "http://#{Config::Configuration.get(:ssg, :host)}:#{Config::Configuration.get(:ssg, :port)}"
end
