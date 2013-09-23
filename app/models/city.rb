class City < ActiveRecord::Base
  extend FriendlyId
  
	has_many :issues
  has_many :users
	
  friendly_id :name, :use => [:slugged]
	
	def self.for_search
	  return City.where(:active => true).all
  end
  
  def friendly_id_link
    return self.friendly_id
  end

  #
  # Returns true if created, false if edited
  #
  def self.create_or_edit(params)
    city = (city_id = params[:city_id]).empty? ? City.new : City.find(city_id)
    city.name = params[:city_name]
    city.active = params[:city_active]
    city.lat  = params[:lat]
    city.long = params[:lon]
    city.save!

    return city_id.empty?
  end
  
end
