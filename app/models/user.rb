class User < ActiveRecord::Base
  ROLE_GUEST  = 1
  ROLE_USER   = 2
  
  GUEST_USER = User.new(:role => ROLE_GUEST, :first_name => 'Guest')
  
  
  has_many  :issues
  
  
  def self.fb_client
    return OAuth2::Client.new(Config::get(:fb, :application_id), Config::get(:fb, :secret_key), :site => Config::get(:fb, :site_url))
  end
  
  def self.guest_user
    return GUEST_USER
  end
  
end