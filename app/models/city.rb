class City < TranslatedBase
  extend FriendlyId
  include SoftDelete
  
	has_many :issues
  has_many :users
  has_many :updates, through: :issues

  belongs_to :image
	
  friendly_id :name, :use => [:slugged]

  default_scope where(:deleted => false)
	
	def self.for_search
	  return City.all
  end
  
  def friendly_id_link
    return self.friendly_id
  end

  def website_url
    self.website.match(/^http.*/) ? self.website : "http://#{website}"
  end

  def admin_users
    self.users.where(:role => User::ROLE_CITY_ADMIN, :active => true)
  end

  def get_issues_by_status(status = nil) 
    return status.nil? ? issues : issues.where(:status => status)
  end

  #
  # Returns true if created, false if edited
  #
  def self.create_or_edit(params)
    require 'pp'
    pp ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    pp params
    pp ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    city = (city_id = params[:city_id]).empty? ? City.new : City.find(city_id)
    city.name = params[:city_name]
    city.active = params[:city_active]
    city.lat  = params[:lat]
    city.long = params[:lon]
    city.description = params[:description]
    city.website = params[:website]
    # not to delete existing image
    if params[:image_0]
      city.image_id = params[:image_0]
    end
    city.save!

    return city_id.empty?
  end
  
end
