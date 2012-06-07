class Issue < ActiveRecord::Base
  belongs_to 	:area
  belongs_to 	:user

  has_many		:issue_updates
  has_many		:attachments
end