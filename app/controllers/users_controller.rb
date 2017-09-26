# -*- coding: utf-8 -*-
class UsersController < ApplicationController
  before_filter :authenticate, :except =>[:show, :new, :create]
  before_filter :correct_user, :only =>[:edit, :update]
  before_filter :admin_user,   :only => :destroy
  def index
    @users = User.paginate(:page => params[:page], :per_page =>12)
  end
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
  end
  
  def report
    @user = User.find(params[:id])
    @reports = @user.reports.paginate(:page => params[:page])
    #render 'report'
    #render "report"
  end
  
  def course
    @user = User.find(params[:id])
  end
  
  def footprint
    @user = User.find(params[:id])
  end
  
  def food
    @user = User.find(params[:id])
  end
  
  def following
  	@title = "关注"
  	@user  = User.find(params[:id])
  	@users = @user.following.paginate(:page => params[:page])
  	render "show_follow"
  end
  
  def followers
  	@title = "粉丝"
  	@user  = User.find(params[:id])
  	@users = @user.followers.paginate(:page => params[:page])
  	render "show_follow"
  end
  def new
    #@title = "加入我们"
    @user = User.new
  end

  def create
   #显示错误信息 raise params[:user].inspect
    @user = User.new(params[:user])
    if @user.save
      #保存
      sign_in @user
      redirect_to @user , :flash => { :success =>"亲爱的 #{@user.name} 欢迎你！" }
    else
     # @title="注册"
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end
  
      
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
    #It worked
      redirect_to @user  , :flash => { :success => "修改成功！"} 
    else
        render 'edit'
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path , :flash => { :success => "已删除用户！"} 
  end

  private

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin_user
    @user = User.find(params[:id])
    redirect_to(root_path) if !current_user.admin? || current_user?(@user)
  end
end
