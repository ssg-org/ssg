require 'carrierwave/orm/activerecord'

class Image < ActiveRecord::Base
  belongs_to :issue
  belongs_to :update

  mount_uploader :image, ImageUploader
end
