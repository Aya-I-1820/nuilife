class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    @post.likes.create(user: current_user)
    redirect_to @post
  end

  def destroy
    like = @post.likes.find_by(user: current_user)
    like&.destroy
    redirect_to @post
  end

  private
  def set_post
    @post = Post.find(params[:post_id])
  end
end
