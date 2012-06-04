require "#{Dir.pwd}/lib/config/config.rb"

puts "Starting with #{Rails.env} configuration :"
puts Config::APP_CONFIG.inspect
