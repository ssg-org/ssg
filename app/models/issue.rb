class Issue < ActiveRecord::Base
  extend FriendlyId

	OPEN 		= 1
	IN_PROGRESS	= 2
	FIXED		= 3

  attr_accessible :title, :category, :city, :description, :user, :lat, :long

  belongs_to 	:user
  belongs_to  :category
  belongs_to	:city

  has_many		:comments
  has_many    :images
  has_many    :votes
  
  friendly_id :title, :use => [:slugged]
  
  def self.get_issues(params, limit=9, offset=0)
  	query = Hash.new

    # Get category, status and city params
    if (!params[:category].nil?)
      query[:category_id] = params[:category]
    end

    if (!params[:status].nil?)
      query[:status] = params[:status]
    end

    if (!params[:city].nil?)
      query[:city_id] = params[:city]
    end

    if (query.empty?)
  		@issues_relation = Issue
	  else
		  @issues_relation = Issue.where(query)
    end
    
    return @issues_relation.includes([:images, :category]).limit(limit).offset(offset)
  end
end