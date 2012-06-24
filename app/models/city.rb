class City < ActiveRecord::Base
  extend FriendlyId
  
	has_many :issues
	
  friendly_id :name, :use => [:slugged]
	
	def self.for_search
	  return City.all
  end
  
  def friendly_id_link
    return self.friendly_id
  end
  
end
