class Update < ActiveRecord::Base
  belongs_to :user
  belongs_to :issue

  SHORT_TEXT_SIZE = 100

  def short_text
  	return text.size > SHORT_TEXT_SIZE ? "#{text.first(SHORT_TEXT_SIZE - 3)}..." : text
  end
end