class RelationshipsController < ApplicationController
  def follow_user
    @user = User.find_by! user_name: params[:user_name]
    if current_user.follow @user.id
      respond_to do |format|
        msg = { status: "ok", message: "Follow #{@user.user_name}", count: @user.followers.count }
        format.json { render json: msg }
      end
    else
      render json: { error: "Forbidden" }, status: :forbidden
    end
  end

  def unfollow_user
    @user = User.find_by! user_name: params[:user_name]
    if current_user.unfollow @user.id
      respond_to do |format|
        msg = { status: "ok", message: "Unfollowed #{@user.user_name}", count: @user.followers.count }
        format.json { render json: msg }
      end
    else
      render json: { error: "Forbidden" }, status: :forbidden
    end
  end
end
