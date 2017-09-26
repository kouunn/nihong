class Comment < ActiveRecord::Base
  attr_accessible :comment, :commentable_id, :commentable_type
  include ActsAsCommentable::Comment

  belongs_to :commentable, :polymorphic => true

  default_scope -> { order('created_at ASC') }

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable

  # NOTE: Comments belong to a user
  belongs_to :user
  
   private
  
  def self.followed_by(user)
  	followed_ids = %(SELECT followed_id FROM relationships 
  		             WHERE follower_id = :user_id)
  		             
  	where("user_id IN(#{followed_ids}) OR user_id = :user_id ",
  		  :user_id => user)
  end

end
