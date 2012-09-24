require 'carrierwave/orm/activerecord'

class Image < ActiveRecord::Base
  	belongs_to  :issue

  	mount_uploader :image, ImageUploader
    
end