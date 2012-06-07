class Attachment < ActiveRecord::Base
	JPG = 1

	belongs_to :user
	belongs_to :issue
end