class HelpsController < ApplicationController

  before_filter :authenticate
  before_filter :authorized_user, :only => :destroy
  
  def show
    @help = Help.find(params[:id])
  end
  
  def create
    @help = current_user.helps.build(params[:help])
    if @help.save
      redirect_to home_path, :flash =>{ :success =>"发布成功！"}
    else
      @feed_items = []
      render 'pages/home'
    end
  end

  def destroy
  	   @help.destroy
       redirect_to home_path, :flash =>{ :success =>"删除成功！"}
  end
  
  private
  	def authorized_user
  		@help = Help.find(params[:id])
  		redirect_to root_path unless current_user?(@help.user)
  	end
end
