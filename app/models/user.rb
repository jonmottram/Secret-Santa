require "digest/sha1"

class User < ActiveRecord::Base
  has_many :wants, :order => :position

  attr_accessor :pw, :pw2
  attr_accessible :username, :pw, :email
  validates_uniqueness_of :username, :on => :create
  validates_presence_of :username, :on => :create

  def before_create
    if @pw != nil
      self.password = User.hash_password(self.pw)
    else
      self.password = nil
    end
  end

  def before_update
    # if the pw field is set, hash it
    if @pw != nil
      self.password = User.hash_password(self.pw)
    end
  end
  
  def after_create
    @pw = nil
    @pw2 = nil
  end

  def self.login(username, pass)
    password = hash_password(pass.downcase || '')
    find(:first,
         :conditions => ["username=? and password=?", username.downcase, password])
  end
  def try_login
    User.login(self.username, self.pw)
  end

  def is_logged_in
    # probably a cleaner way to do this...
    # username is set to something for a logged-in user
    username != nil && username != ''
  end

  def can_be_santa_of(other)
    @family != other.family
  end

  private
  def self.hash_password(pass)
    Digest::SHA1.hexdigest(pass)
  end

end
