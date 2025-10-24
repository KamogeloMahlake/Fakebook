class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [ :create, :destroy ]

  def create
    @like = @post.likes.build(user: current_user)
    if @like.save
      respond_to do |format|
        msg = { status: "ok", message: "Like created", count: @post.likes.count, id: @like.id }
        format.json { render json: msg }
      end
    else
      render json: { error: "Forbidden" }, status: :forbidden

    end
  end

  def destroy
    @like = @post.likes.find(params[:id])
    if @like.user != current_user
      render json: { error: "Forbidden" }, status: :forbidden
    else
      @like.destroy
      respond_to do |format|
        msg = { status: "ok", message: "Like deleted", count: @post.likes.count  }
        format.json { render json: msg }
      end
    end
  end

  private

  def like_params
    params.require(:like).permit(:post_id)
  end

  def set_post
    @post = Post.find(params[:post_id])
  end
end
