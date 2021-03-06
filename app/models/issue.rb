require 'config/config'
require 'ostruct'

class Issue < TranslatedBase
  extend FriendlyId

  REPORTED      = 1
  IN_PROGRESS   = 2
  FIXED         = 3
  DELETED       = 4

  ISSUES_PER_PAGE = 30

  TRANS_KEYS = ['none','reported','in_progress','fixed','deleted']

  default_scope where('issues.status <> 4')

  attr_accessor :image_url, :short_desc, :issue_url
  attr_accessible  :title, :category, :city, :description, :user, :lat, :long, :status, :vote_count, :view_count, :comment_count, :share_count, :created_at, :sort_date
  
  belongs_to 	:user
  belongs_to  :category
  belongs_to	:city

  has_many		:comments, :dependent => :destroy
  has_many    :images, :dependent => :destroy
  has_many    :issue_images, class_name: 'Image', conditions: { :update_id => nil }
  has_many    :update_images, class_name: 'Image', conditions: 'update_id IS NOT NULL'
  has_many    :votes, :dependent => :destroy
  has_many    :unique_views, :dependent => :destroy
  has_many    :updates
  
  friendly_id :title, :use => [:slugged]

  def self.with_paging(page)
    paginate(:page => page, :per_page => ISSUES_PER_PAGE)
  end

  def self.sort_by(column=nil)
    sort_criteria = column || 'vote_count DESC'
    order(sort_criteria)
  end

  def mark_as_viewed(user_uniq_cookie_id) 
    uniq_view = self.unique_views.where(:session => user_uniq_cookie_id).first

    if (uniq_view)
      # count if 1hour diff (config file)
      if (Config::Configuration.get(:misc, :unique_view_epsilon).to_f < (Time.now - uniq_view.viewed_at))
        self.session_view_count += 1
        uniq_view.viewed_at = Time.now
        uniq_view.save!
      end
    else
      UniqueView.create({:session => user_uniq_cookie_id, :issue_id => self.id, :viewed_at => Time.now })
      self.session_view_count += 1
    end

    # Non unique view count
    self.view_count += 1
    self.save!
  end

  def setup_json_attributes!()
    @image_url = images.first.image.issue_full.url unless images.empty?
    @short_desc = ApplicationController.helpers.truncate(self.description, :length => 200)
    @issue_url = Rails.application.routes.url_helpers.issue_path(self.friendly_id)
  end

  # Limit removed
  def self.get_geo_issues(south_west_geo, north_east_geo) #, limit)
    sw_lat = south_west_geo[:lat]
    sw_long = south_west_geo[:long]
    ne_lat = north_east_geo[:lat]
    ne_long = north_east_geo[:long]

    return Issue.where('lat > ? AND lat < ? AND long > ? AND long < ?', sw_lat, ne_lat, sw_long, ne_long).includes([:images, :user, :category, :city]) #.limit(limit)  
  end

  # get topmost category for issue
  # we need it to fetch icon for marker
  def top_category_id
    Category.check_parent_id(category)
  end

  def get_status
    trans_key = TRANS_KEYS[self.status]
    I18n.t("issues.status.#{trans_key}")
  end

  def self.translate_status(id)
    trans_key = TRANS_KEYS[id.to_i]
    I18n.t("issues.status.#{trans_key}")
  end

  def self.all_statuses
    results = []
    3.downto(1) do |i|
      trans_key = TRANS_KEYS[i]
      results << OpenStruct.new(:id => i, :name => I18n.t("issues.status.#{trans_key}"))
    end
    results
  end

  def self.user_statuses
    results = []
    [1,2,3].each do |i|
      trans_key = TRANS_KEYS[i]
      results << OpenStruct.new(:id => i, :name => I18n.t("issues.status.#{trans_key}"))
    end

    results
  end

  def image_url
    if images.length > 0
      return  images.first.image.issue_thumb.url
    else
      return ApplicationController.helpers.image_path("icons/#{category.icon}.jpg")
    end
  end

  def as_json(options={})
    # also can be solved by adding :methods to options hash
    response = super(options)
    response[:image_url] = self.image_url
    response[:top_category_id] = self.top_category_id
    response[:short_desc] = self.short_desc
    response[:issue_url] = self.issue_url
    response
  end

  def twiter_share_link(url)
    return "https://twitter.com/share?text=#{title}&url=#{url}&hashtags=ulicaba"
  end
  
  def self.get_issues(params, limit=9, offset=0)
  	query = Array.new
    values = Hash.new

    # Order
    order_by = 'sort_date desc'

    # Get category, status and city params
    if (!params[:category].blank?)
      #query << 'category_id = :category_id'
      #values[:category_id] = params[:category]
      query << 'category_id IN (:category_ids)'
      # category id + all its subcategory ids
      values[:category_ids] = [params[:category]].concat(Category.subcategories_ids(params[:category]))
    end

    if (!params[:status].blank?)
      query << 'status = :status'
      values[:status] = params[:status]
    end

    if (!params[:city].blank?)
      query << 'city_id = :city_id'
      values[:city_id] = params[:city]
    end

    if (!params[:date].blank?)
      date = params[:date]

      if (date == 'today')
        start_time = Time.now.beginning_of_day
        end_time = Time.now.end_of_day
      elsif (date == 'week')
        start_time = Time.now.beginning_of_week
        end_time = Time.now.end_of_week
      elsif (date == 'month')
        start_time = Time.now.beginning_of_month
        end_time = Time.now.end_of_month
      end

      query << '(created_at > :start_time AND created_at < :end_time)'
      values[:start_time] = start_time
      values[:end_time] = end_time 
    end

    if (!params[:featured].blank?)
      sort_by = params[:featured]

      if (sort_by == 'viewed')
        order_by = 'session_view_count desc'
      elsif (sort_by == 'votes')
        order_by = 'vote_count desc'
      elsif (sort_by == 'discussed')
        order_by = 'comment_count desc'
      elsif (sort_by == 'updated')
        order_by = "coalesce(updates.created_at, date('now')) desc"
      #elsif (sort_by == 'updated')
       # order_by = 
      end
    end
    
    if (query.empty?)
  		@issues_relation = Issue
    else
		  @issues_relation = Issue.where(query.join(' AND '), values)
    end
    
    if !params[:featured].blank? && sort_by == 'updated'
      return Issue.select("issues.*, coalesce(updates.created_at, date('now')) as new_order").joins("left join updates on issues.id = updates.issue_id").order("new_order desc").uniq('issues.id')
    else
      return @issues_relation.limit(limit).offset(offset).order(order_by).includes([:user, :city, :category, :images, :category, :updates])
    end
  end


  def is_new
    return self.created_at > 3.days.ago ? true : false
  end

  def is_changed
    return self.created_at < self.sort_date && self.sort_date > 3.days.ago ? true : false
  end

  def get_ribbon(lang = nil)
    
    if is_changed
      return "izmjena_#{lang}.png"
    elsif is_new
      return "novo_#{lang}.png"
    else
      return ""
    end

    return @issues_relation.limit(limit).offset(offset).order(order_by).includes([:user, :city, :category, :images, :category, :updates])
  end

  def assign_images(image_ids)
    image_ids = Array(image_ids)
    Image.where(:id => image_ids).update_all({ :issue_id => id })
  end

  def feed_items
    (comments + updates).sort { |a, b| a.created_at <=> b.created_at }
  end
end
