class Issue < ActiveRecord::Base
  belongs_to 	:area
  belongs_to 	:user

  has_many		:issue_update
end