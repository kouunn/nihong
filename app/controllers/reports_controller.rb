class ReportsController < ApplicationController

  before_filter :authenticate
  before_filter :authorized_user, :only => :destroy
  
  def show
    @report = Report.find(params[:id])
  end
  
  def create
    @report = current_user.reports.build(params[:report])
    if @report.save
      redirect_to home_path, :flash =>{ :success =>"发布成功！"}
    else
      @feed_items = []
      render 'pages/home'
    end
  end

  def destroy
  	   @report.destroy
       redirect_to home_path, :flash =>{ :success =>"删除成功！"}
  end
  
  private
  	def authorized_user
  		@report = Report.find(params[:id])
  		redirect_to root_path unless current_user?(@report.user)
  	end
end
