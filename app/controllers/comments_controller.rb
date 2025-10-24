class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def index
    @comments = @post.comments.order("created_at ASC")

    respond_to do |format|
      format.html { render layout: !request.xhr? }
    end
  end

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user_id = current_user.id

    if @comment.save
      respond_to do |format|
        format.html { redirect_to post_path(@post) }
        format.js
      end
    else
      flash.now[:alert] = "Check the comment form something went horribly wrong."
      redirect_to(post_path(@post))
    end
  end

  def destroy
    @comment = @post.comments.find(params[:id])
    if @comment.user_id == current_user.id
      @comment.destroy
      respond_to do |format|
        msg = { status: "ok", message: "Comment Deleted" }
        format.json { render json: msg }
      end
    else
      render json: { error: "Forbidden" }, status: :forbidden
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:content)
    end

    def set_post
      @post = Post.find(params[:post_id])
    end
end
