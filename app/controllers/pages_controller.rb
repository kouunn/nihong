class PagesController < ApplicationController
  def home
    if signed_in?
  	@micropost = Micropost.new
  	@report = Report.new
  	@help = Help.new
    @feed_items = current_user.feed.paginate( :page => params[:page])
    @feed_helps = current_user.feed_help.paginate( :page => params[:page])
    @feed_reports = current_user.feed_report.paginate( :page => params[:page])
     #评论
    
    @comment = @micropost.comments.build
    @micropost.comments.pop
 
  	end
  
end


  def friends
  end

  def groups
  end

  def activities
  end
end
