class MicropostsController < ApplicationController

  before_filter :authenticate
  before_filter :authorized_user, :only => :destroy
  
  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      redirect_to home_path, :flash =>{ :success =>"发布成功！"}
    else
      @feed_items = []
      render 'pages/home'
    end
  end
  def show
    @micropost = Micropost.find(params[:id])

  end


  def destroy
  	   @micropost.destroy
       redirect_to home_path, :flash =>{ :success =>"删除成功！"}
  end
  
  private
  	def authorized_user
  		@micropost = Micropost.find(params[:id])
  		redirect_to root_path unless current_user?(@micropost.user)
  	end
end
