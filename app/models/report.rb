class Report < ActiveRecord::Base
  attr_accessible :content, :course, :title, :user_id
  acts_as_commentable
  belongs_to :user

  validates :content, :presence => true
  validates :user_id, :presence => true

  default_scope  :order => 'reports.created_at DESC'
  
  scope :from_users_followed_by, lambda { |user| followed_by(user) }
  
 private
  
  def self.followed_by(user)
  	followed_ids = %(SELECT followed_id FROM relationships 
  		             WHERE follower_id = :user_id)
  		             
  	where("",:user_id => user)
  end
  
end


