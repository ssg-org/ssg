require "#{Dir.pwd}/lib/config/config.rb"

config_scope = Rails.env

puts "Starting with configuration (#{config_scope}):"

Config::Configuration.reload(config_scope)

puts Config::Configuration.get_root(config_scope).inspect