class Comment < ActiveRecord::Base
  belongs_to :issue
  belongs_to :user

  attr_accessible :user, :text, :admin_comment, :status_first, :status_second

  def is_owned?(app_user)
    self.user.id == app_user.id
  end

  def admin?()
    self.admin_comment
  end

  # user changing status
  def admin_text()
    "#{I18n.t('issues.status.change_from')} '#{Issue.translate_status(self.status_first)}' #{I18n.t('issues.status.change_to')} '#{Issue.translate_status(self.status_second)}'"
  end

end