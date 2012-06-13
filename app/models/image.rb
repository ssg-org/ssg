class Image < ActiveRecord::Base
  belongs_to  :issue
  
  has_attached_file :file, :styles => { :medium => "640x480",:thumb => "320x200"} 
  # :processor => "mini_magick", 
  # :convert_options => { 
  #   :medium => "-compose Copy -gravity center -extent 680x335", 
  #   :thumb => "-compose Copy -gravity center -extent 150x150", 
  # } ,
  # :storage => :s3,
  # :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
  # :path => "/:style/:id/:id"+"_1"
  
end