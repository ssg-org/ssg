class UniqueView < ActiveRecord::Base
	attr_accessible	:session, :issue_id, :viewed_at

	belongs_to	:issue
end