class CommentsController < ApplicationController
  def create
  	  @commentable = Comment.find_commentable(params[:comment][:commentable_type], params[:comment][:commentable_id])
    if @commentable
      @comment = @commentable.comments.build(params[:comment])
      if @comment.save
        redirect_to home_path, :notice => "Thanks for the comment."
      else
        flash.now[:alert] = "You had some errors for your comment."  # edited 10/28/10 use 'flash.now' instead of 'flash'
        render_error_page
      end
    else
      redirect_to root_url, :alert => "You can't do that."
    end
  end
  
  def show
  	@comment = Comment.find(params[:id])
    #@comment = @micropost.comments.build
    #@micropost.comments.pop
  end
  
   private
  def show_page_url
    case @commentable.class.name
    when "Post" then post_url(@commentable)
    else @commentable
    end
  end

  def render_error_page
    model_name = @commentable.class.name
    instance_variable_set("@#{model_name.downcase}", @commentable)
    render "#{model_name.underscore.downcase.pluralize}/show"
  end
  
end