class PostsController < ApplicationController
  before_action :set_post, only: [ :show, :edit, :update, :destroy ]
  before_action :authenticate_user!
  before_action :owned_post, only: [ :edit, :update, :destroy ]

  def browse
    @posts = Post.all.order("created_at DESC").page params[:page]
  end

  def index
    begin
      @posts = (Post.of_followed_users(current_user.following) + current_user.posts).order("created_at DESC").page params[:page]

      if @posts.length == 0
        @posts = Post.all.order("created_at DESC").page params[:page]
      end
    rescue
      @posts = Post.all.order("created_at DESC").page params[:page]
    end
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      flash[:success] = "Your post has been created"
      redirect_to @post
    else
      flash.now[:alert] = "Your new post couldn't be created! Please check the form"
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @post.update(post_params)
      flash[:success] = "Post updated."
      redirect_to(post_path(@post))
    else
      flash.now[:alert] = "Update failed. Please check the form."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path
  end

  private
    def post_params
      params.expect(post: [ :text, images: [] ])
    end

    def set_post
      @post = Post.find(params[:id])
    end

    def owned_post
      unless current_user == @post.user
        flash[:alert] = "That post doesn't belong to you!"
        redirect_to root_path
      end
    end
end
