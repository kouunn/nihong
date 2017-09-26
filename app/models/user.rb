# -*- coding: utf-8 -*-
class User < ActiveRecord::Base
  attr_accessor   :password
  attr_accessible :email, :name, :password, :password_confirmation,
  				  :true_name, :sex, :birthday, :university, :school_year, :love_status, :location, :photo
  
  has_attached_file   :photo,
    				  :styles => { :original => '100x100#', 
    				  			   :small => '50x50#'  },  
 					  :url => "/uploadfiles/:class/:attachment/:id/:basename/:style.:extension",
    				  :path => ":rails_root/public/uploadfiles/:class/:attachment/:id/:basename/:style.:extension"
  validates_attachment_presence :photo    
  validates_attachment_size :photo, :less_than => 5.megabytes    
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png','image/jpg','image/bmp']   
  
  has_many :comments,:dependent => :destroy
  has_many :helps,    :dependent => :destroy					  
  has_many :reports,    :dependent => :destroy			  
  has_many :microposts,    :dependent => :destroy
  has_many :relationships, :dependent => :destroy,
  						   :foreign_key => "follower_id"
  
  has_many :reverse_relationships, :dependent => :destroy,
  						   		   :foreign_key => "followed_id",
  						   		   :class_name => "Relationship"
  						   		   
  has_many :following,     :through => :relationships, :source => :followed  						   
  has_many :followers,     :through => :reverse_relationships, 
  						   :source => :follower
  	
  							   
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  #注册部分
  validates :name,  :presence => true,
                    :length => { :maximum => 50}
                    
                                  
  validates :email, :presence   => true,
                    :format     => { :with => email_regex},
                    :uniqueness => { :case_sensitive => false }
  validates :password, :presence => true,
                       :confirmation => true,
                       :length => {  :within => 6..40 }
  #个人资料                       
  validates :location,  :presence => true    
  validates :sex,  :presence => true                     
                        
  before_save :encrypt_password

  scope :admin, where(:admin => true)
  
  #validates_presence_of :name, :message => "不能为空" 
  #validates_presence_of :email, :message => "不能为空" 
#  validates_length_of   :title, :in => 2..10, :message => "长度不正确" 

  
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  def feed
  	Micropost.from_users_followed_by(self)
  	#Micropost.where("user_id = ?",id)
  end
  def feed_comment
  	#Comment.where("user_id = ?",id)
  	#Micropost.where("user_id = ?",id)
  end
  
  
  def feed_micropost
  	Micropost.from_users_followed_by(self)
  	#Micropost.where("user_id = ?",id)
  end
  
  def feed_report
    Report.from_users_followed_by(self)
  end
  
  def feed_help
  	Help.from_users_followed_by(self)
  	#Micropost.where("user_id = ?",id)
  end
  
  def following?(followed)
  	relationships.find_by_followed_id(followed)
  end
  
  def follow!(followed)
  	relationships.create!(:followed_id => followed.id)
  end
   
  def unfollow!(followed)
	relationships.find_by_followed_id(followed).destroy
  end
  
  class << self
    def authenticate(email,submitted_password)
      user = find_by_email(email)
      (user && user.has_password?(submitted_password)) ? user : nil
     # 和上面一样
     # return nil if user.nil?
     # return user if user.has_password?(submitted_password)
    end
  
    def authenticate_with_salt(id,cookie_salt)
      user = find_by_id(id)
      (user && user.salt == cookie_salt) ? user : nil
    end
  end

  private
    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end
    
    def encrypt(string)
      secure_hash("#{salt}--#{string}") #Not the final implementation!
    end
    
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end
      
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end
