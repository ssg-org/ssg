class Update < ActiveRecord::Base
  belongs_to :user
  belongs_to :issue
  has_many :images

  SHORT_TEXT_SIZE = 100

  def short_text
  	return text.size > SHORT_TEXT_SIZE ? "#{text.first(SHORT_TEXT_SIZE - 3)}..." : text
  end

  def assign_images(image_ids)
    image_ids = Array(image_ids)
    Image.where(:id => image_ids).update_all({ :update_id => id, :issue_id => issue_id })
  end
end
