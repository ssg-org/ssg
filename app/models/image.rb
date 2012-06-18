class Image < ActiveRecord::Base
  belongs_to  :issue
  
  has_attached_file :file, :styles => { :medium => "640x480", :thumb => "198x155\#"} 
  # :storage => :s3,
  # :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
  # :path => "/:style/:id/:id"+"_1"
  
end