class Comment < ActiveRecord::Base
  belongs_to :issue
  belongs_to :user

  attr_accessible :user, :text
end