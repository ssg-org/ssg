class User < ActiveRecord::Base
  ROLE_GUEST  = 1
  ROLE_USER   = 2
  
  GUEST_USER = User.new(:role => ROLE_GUEST, :first_name => 'Guest')

  has_many  :issues
  has_many  :votes
  
  has_many  :follows
  
  def get_follows
    return self.follows.order(:type)
  end
  
  def self.get_categories
    return Category.all
  end

  def self.get_cities
    return City.all
  end
  
  def display_name
    fname = "#{self.first_name} #{self.last_name}"
    if fname.blank?
      fname = self.email
    end
    return fname
  end
  
  def vote_for(issue_id)
    issue = Issue.find(issue_id)
    vote = Vote.where(:user_id => self.id, :issue_id => issue.id).first
    if (issue && vote.nil?)
      Vote.create(:user => self, :issue => issue)
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
  
  def create_issue(title, category_id, city_id, descripion, file_desc)
    ActiveRecord::Base.transaction do
      category = Category.find_by_id(category_id)
      city = City.find_by_id(city_id)

      issue = Issue.create({ :user => self, :title => title, :description => descripion, :category => category, :city => city })
      if (file_desc)
        Image.create({ :issue => issue, :file => file_desc })
      end
      return issue
    end
  end
  
  def guest?
    return self.role & ROLE_GUEST == ROLE_GUEST
  end
  
  def self.exists?(email, pwd)
    usr = User.find_by_email(email)
    if (usr && usr.password_hash = Digest::SHA256.hexdigest(pwd))
      return usr
    end
    
    return nil
  end
  
  def self.guest_user
    return GUEST_USER
  end
  
  def self.fb_client
    return OAuth2::Client.new(Config::get(:fb, :application_id), Config::get(:fb, :secret_key), :site => Config::get(:fb, :site_url))
  end

  def self.twitter_client
    Twitter.configure do |config|
      config.consumer_key = Config::get(:twitter, :consumer_key)
      config.consumer_secret = Config::get(:twitter, :consumer_secret)
      config.oauth_token = Config::get(:twitter, :oauth_token)
      config.oauth_token_secret = Config::get(:twitter, :ouath_secret)
    end
  end
    
  def self.create_fb_user(token, email, fb_id, last_name, first_name, is_active = true, role = User::ROLE_USER)
    user = User.new
    user.email = email
    user.fb_id = fb_id
    user.fb_token = token
    user.last_name = last_name
    user.first_name = first_name
    user.active = is_active
    user.role = role
    user.save
    
    return user
  end
  
end