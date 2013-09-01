class Comment < ActiveRecord::Base
  belongs_to :issue
  belongs_to :user

  attr_accessible :user, :text

  def is_owned?(app_user)
    self.user.id == app_user.id
  end

end