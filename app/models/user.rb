# encoding: UTF-8
class User < TranslatedBase

  include SoftDelete

  ROLE_GUEST            = 1
  ROLE_USER             = 2
  ROLE_CITY_ADMIN       = 3
  ROLE_SSG_ADMIN        = 4

  DUMMY_TWITTER_EMAIL = 'dummy@twitter.com'
  
  GUEST_USER = User.new(:role => ROLE_GUEST, :first_name => 'Guest', :locale => I18n.default_locale)

  LOCALES = [:bs, :en]

  has_many    :issues
  has_many    :votes
  has_many    :follows

  belongs_to  :city
  belongs_to  :image

  DEF_LAT, DEF_LON, DEF_ZOOM_LVL, CITY_ZOOM = 43.855078, 18.395748, 10, 13

  default_scope where(:deleted => false)
  

  def users_lat_long
    self.city.nil? ? [DEF_LAT, DEF_LON] : [self.city.lat.to_f, self.city.long.to_f]
  end

  def users_zoom
    self.city.nil? ? DEF_ZOOM_LVL : CITY_ZOOM
  end

  def get_city_id
    self.city.nil? ? -1 : self.city.id
  end

  def get_follows
    return self.follows.order(:type)
  end
  
  # only parent categories are returned here
  def get_categories
    get_sub_categories(nil)
  end

  def get_sub_categories(parent_id)
    Category.where(:parent_id => parent_id).all
  end

  def get_all_categories()
    parent_categories = get_categories()
    results = []
    parent_categories.each do |cat|
      results << OpenStruct.new(:id => cat.id, :name => cat.name)
      sub_categories = get_sub_categories(cat.id)
      sub_categories.each do |sub_cat|
        results << OpenStruct.new(:id => sub_cat.id, :name => "·· #{sub_cat.name}")
      end
    end

    results
  end

  def get_cities
    return City.order(:name)
  end

  def self.ssg_admins
    User.where(:role => ROLE_SSG_ADMIN, :active => true)
  end

  def self.get_admin_roles
    results = []
    results << OpenStruct.new( :name => 'Korisnik', :value => ROLE_USER)
    results << OpenStruct.new( :name => 'Općinski Administrator', :value => ROLE_CITY_ADMIN)
    results << OpenStruct.new( :name => 'SSG Administrator', :value => ROLE_SSG_ADMIN)
    results
  end

  def self.get_locales
    results = []
    results << OpenStruct.new( :name => 'BHS', :value => :bs_latin)
    results << OpenStruct.new( :name => 'БХС', :value => :bs_cyrillic)
    results << OpenStruct.new( :name => 'ENG', :value => :en)
    results
  end

  def fbuser?
    return !self.fb_id.nil?
  end

  def ssg_admin?
    return (self.role == ROLE_SSG_ADMIN)
  end
  
  def city_admin?
    return (self.role == ROLE_CITY_ADMIN)
  end
  
  def is_good_password?(pwd)
    return self.password_hash.eql? Digest::SHA256.hexdigest(pwd)
  end

  def full_name
    if self.first_name.blank? && self.last_name.blank?
      return self.email
    else
      return "#{self.first_name} #{self.last_name}"
    end
  end

  def avatar(size = :small)
    if !self.image_id.nil?
      return size == :full ? image.image.logo_full : image.image.logo_small
    elsif fbuser? 
      return "http://graph.facebook.com/#{fb_id}/picture?type=square"
    else
      return '/assets/no_avatar.png'
    end
  end

  def formated_website
    if self.website.match(/^(http|https):\/\/.*/ix)
      return self.website
    else
      return "http://#{website}"
    end
  end
  
  def comment_on_issue(issue_id, text, admin = false, status_1 = 0, status_2 = 0)
    # invalid case change to same status
    return if admin && status_1.to_i == status_2.to_i
    ActiveRecord::Base.transaction do
      issue = Issue.find(issue_id)
      issue.comments << Comment.new(:text => text, :user => self, :admin_comment => admin, :status_first => status_1.to_i, :status_second => status_2.to_i)
      issue.comment_count += 1
      issue.save
    end
  end

  def vote_for(issue_id)
    ActiveRecord::Base.transaction do
      issue = Issue.find(issue_id)
      # You can't vote for your issues
      if (issue.user_id != self.id)
        vote = Vote.where(:user_id => self.id, :issue_id => issue.id).first
        if (issue && vote.nil?)
          Vote.create(:user => self, :issue => issue)
        end
        issue.vote_count += 1
        issue.save
      end
    end
  end

  def change_status_for(issue_id, status)
    ActiveRecord::Base.transaction do
      issue = Issue.find(issue_id)
      # Only admin and user who created issue can change state
      if (issue.user_id == self.id || self.ssg_admin?)
        old_status   = issue.status
        issue.status = status.to_i
        issue.save

        # Add Comment
        comment_on_issue(issue.id, 'status comment', true, old_status, status)

        # Send notifications
        notify_issue_updated(issue)
      end
    end
  end

  def unvote_for(issue_id)
    ActiveRecord::Base.transaction do
      issue = Issue.find(issue_id)
      # You can't vote for your issues
      if (issue.user_id != self.id)
        vote = Vote.where(:user_id => self.id, :issue_id => issue.id).first
        if (vote)
          vote.destroy
        end
        issue.vote_count -= 1
        if (issue.vote_count < 0)
          issue.vote_count = 0
        end
        issue.save
      end
    end
  end
  
  def follow(issue_id)
    issue = Issue.find(issue_id)
    follow = FollowIssue.where(:user_id => self.id, :follow_ref_id => issue.id).first
    if (issue && follow.nil?)
      FollowIssue.create(:user => self, :follow_issue => issue)
    end
  end
  
  def follow_user(user_id)
    user = User.find(user_id)
    follow = FollowUser.where(:user_id => self.id, :follow_ref_id => user.id).first
    if (user && follow.nil?)
      FollowUser.create(:user => self, :follow_user => user)
    end
  end
  
  def create_issue(title, category_id, city_id, descripion, lat, long, image_ids)
    ActiveRecord::Base.transaction do
      category = Category.find(category_id)
      city = City.find(city_id)

      issue = Issue.new({ 
        :user => self, 
        :title => title, 
        :description => descripion, 
        :category => category, 
        :city => city,
        :lat => lat,
        :long => long
      })
      issue.save

      issue.assign_images(image_ids)

      return issue
    end
  end

  def create_issue_seed(title, category_id, city_id, descripion, lat, long, image_ids, status, created_ts, vote_c, view_c, comments_c, share_c)
    ActiveRecord::Base.transaction do
      category = Category.find(category_id)
      city = City.find(city_id)

      issue = Issue.new({ 
        :user => self, 
        :title => title, 
        :description => descripion, 
        :category => category, 
        :city => city,
        :lat => lat,
        :long => long,
        :status => status,
        :vote_count => vote_c,
        :view_count => view_c,
        :comment_count => comments_c,
        :share_count => share_c,
        :created_at => created_ts
      })
      issue.save

      Image.update_all({ :issue_id => issue.id}, { :id => image_ids })

      return issue
    end
  end
  
  def guest?
    return self.role & ROLE_GUEST == ROLE_GUEST
  end

  def user_type
    case role
    when ROLE_GUEST
      "Guest"
    when ROLE_USER
      "Korisnik"
    when ROLE_CITY_ADMIN
      "Administrativni Korisnik"
    when ROLE_SSG_ADMIN
      "SSG Admin"
    else
      "Rola nije definisana"
    end
  end

  def self.exists?(email, pwd)
    usr = User.find_by_email(email)
    if (usr && usr.password_hash == Digest::SHA256.hexdigest(pwd))
      return usr
    end
    
    return nil
  end

  def notify_issue_updated(issue)
    # Send email notifications to issue creator
    UserMailer.notify_issue_updated(issue.user, self, issue).deliver

    # Send emails to all active city admins
    issue.city.admin_users.each do |city_admin|
      UserMailer.notify_issue_updated(city_admin, self, issue).deliver unless city_admin == issue.user
    end

    # Send emails to all system admins
    User.ssg_admins.each do |ssg_admin|
      UserMailer.notify_issue_updated(ssg_admin, self, issue).deliver unless ssg_admin == issue.user            
    end
  end

  def self.send_community_admin_mails(url, city_id)
    users = User.where(:city_id => city_id, :role => ROLE_CITY_ADMIN).all
    users.each do |user|
      UserMailer.created(user, url).deliver
    end

    # mail goes to predfined user to be notifed about all emails
    UserMailer.notify_created(City.find(city_id), url).deliver
  end

  #
  # Returns user only with ssg admin
  #
  def self.user_ssg_admin?(email, pwd)
    usr = exists?(email, pwd)
    usr && usr.active && (usr.ssg_admin?) ? usr : nil
  end
  
  #
  # Returns user only with ssg admin
  #
  def self.user_admin?(email, pwd)
    usr = exists?(email, pwd)
    usr && usr.active && usr.city_admin? ? usr : nil
  end
  
  def self.guest_user
    return GUEST_USER
  end
  
  #
  # Login/Signup/Signout methods
  #
  def self.fb_client
    return OAuth2::Client.new(Config::Configuration.get(:fb, :application_id), Config::Configuration.get(:fb, :secret_key), :site => Config::Configuration.get(:fb, :site_url))
  end

  def self.create_fb_user(token, email, fb_id, last_name, first_name, is_active = true, role = User::ROLE_USER)
    user = User.new
    user.email = email
    user.uuid = UUIDTools::UUID.random_create.to_s
    user.fb_id = fb_id
    user.fb_token = token
    user.last_name = last_name
    user.first_name = first_name
    user.active = is_active
    user.role = role
    user.locale = I18n.default_locale
    user.save
    
    return user
  end

  def self.create_ssg_user(email, pwd, city_id, first_name, last_name)

    user = User.find_by_email(email)

    # New user
    if user.nil?
      user = User.new(:active => false)
    end

    # Inactive user - send email again
    if (user.active == false)
      user.email = email
      user.password_hash = Digest::SHA256.hexdigest(pwd)
      user.uuid = UUIDTools::UUID.random_create.to_s
      user.active = false
      user.role = ROLE_USER
      user.first_name = first_name
      user.last_name = last_name
      user.city_id = city_id
      user.locale = I18n.default_locale

      return user
    # Active user
    else
      return nil
    end
  end

  def self.verify(id, uuid)
    user = User.where("id = ? and uuid = ?", id, uuid).first
    # Only inactive users can be activated
    if (!user.nil? && user.active == false)
      user.active = true;
      user.save
      return user
    else
      return nil
    end
  end

  def create_ssg_admin_user(email, city_id, first_name, last_name, role, url)
    user = User.create_ssg_user(email, Digest::SHA1.hexdigest(Time.now().to_s), city_id, first_name, last_name)
    
    unless user.nil?
      user.role = role
      # user.first_name = first_name
      # user.last_name = last_name
      user.active = true
      user.save

      forgot_pass = create_random_reset_password(user)
      UserMailer.notify_admin_user_creation(user, forgot_pass.token, url).deliver
    end
  end

  def create_random_reset_password(user)
    forgot_pass = ForgotPassword.new
    forgot_pass.user = user
    forgot_pass.token = Digest::SHA1.hexdigest(Time.now().to_s + user.email)
    forgot_pass.save!
    return forgot_pass
  end

  def ssg_admin_update(params)
    user = User.find(params[:id])
    user.first_name = params[:user][:first_name]
    user.last_name = params[:user][:last_name]
    user.email = params[:user][:email]
    user.city_id = params[:user][:city_id]
    user.active = params[:user][:active]
    user.role = params[:user][:role]

    user.save!
  end

  def settings_update(params)
    self.first_name = params[:user][:first_name]
    self.last_name = params[:user][:last_name]
    self.city_id = params[:user][:city_id]
    self.website = params[:user][:website] if valid?(params[:user][:website])
    self.description = params[:user][:description]

    # locale includes script: example bs_latin, bs_cyrilic
    self.locale = params[:user][:locale].to_s.split("_")[0]
    self.script = params[:user][:locale].to_s.split("_")[1] rescue nil

    if params[:image_count] && params[:image_count].to_i > 0
      last_image = params[:image_count].to_i - 1
      self.image_id = params["image_#{last_image}"]
    end

    if params[:password1] && params[:password2]
      if !params[:password1].strip.empty? && params[:password1].eql?(params[:password2])
        self.password_hash = Digest::SHA256.hexdigest(params[:password1])
      end
    end

    self.save
  end

  def get_issues_by_status(status = nil) 
    return status.nil? ? issues : issues.where(:status => status)
  end

  require 'uri'

  private
  def valid?(uri)
    uri.nil? || !!URI.parse(uri)
  rescue
    false
  end

end