class User < ActiveRecord::Base

  ROLE_GUEST            = 1
  ROLE_USER             = 2
  ROLE_COMMUNITY_ADMIN  = 3
  ROLE_SSG_ADMIN        = 4
  
  GUEST_USER = User.new(:role => ROLE_GUEST, :first_name => 'Guest', :locale => I18n.locale)

  has_many    :issues
  has_many    :votes
  has_many    :follows
  belongs_to  :city

  DEF_LAT, DEF_LON, DEF_ZOOM_LVL, CITY_ZOOM = 43.855078, 18.395748, 10, 13
  

  def users_lat_long
    self.city.nil? ? [DEF_LAT, DEF_LON] : [self.city.lat.to_f, self.city.long.to_f]
  end

  def users_zoom
    self.city.nil? ? DEF_ZOOM_LVL : CITY_ZOOM
  end

  def get_follows
    return self.follows.order(:type)
  end
  
  def get_categories
    return Category.all
  end

  def get_cities
    return City.all
  end

  def fbuser?
    return !self.fb_id.nil?
  end

  def ssg_admin?
    return (self.role == ROLE_SSG_ADMIN)
  end
  
  def display_name
    return self.username
  end

  def full_name
    fname = "#{self.first_name} #{self.last_name}"
    if fname.blank?
      fname = self.email
    end
    return fname
  end

  def avatar
    fbuser? ? "http://graph.facebook.com/#{fb_id}/picture" : '/assets/no_avatar.png'
  end
  
  def comment_on_issue(issue_id, text)
    ActiveRecord::Base.transaction do    
      issue = Issue.find(issue_id)
      issue.comments << Comment.new(:text => text, :user => self)
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

      Image.update_all({ :issue_id => issue.id}, { :id => image_ids })

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

  def self.exists?(username, pwd)
    usr = User.find_by_username(username)
    if (usr && usr.password_hash == Digest::SHA256.hexdigest(pwd))
      return usr
    end
    
    return nil
  end

  #
  # Returns user only with ssg admin
  #
  def self.user_ssg_admin?(username, pwd)
    usr = exists?(username, pwd)
    usr && usr.active && usr.ssg_admin? ? usr : nil
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

  def self.create_ssg_user(username, email, pwd, city_id)

    user = User.find_by_username(username)

    # New user
    if user.nil?
      user = User.new(:active => false)
    end

    # Inactive user - send email again
    if (user.active == false)
      user.username = username
      user.email = email
      user.password_hash = Digest::SHA256.hexdigest(pwd)
      user.uuid = UUIDTools::UUID.random_create.to_s
      user.active = false
      user.role = ROLE_USER
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
end