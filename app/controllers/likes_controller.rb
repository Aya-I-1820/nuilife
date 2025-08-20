# app/controllers/likes_controller.rb
class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    @post.likes.find_or_create_by!(user: current_user)
    redirect_to [@post.nui, @post]
  end

  def destroy
    @post.likes.find_by(user: current_user)&.destroy
    redirect_to [@post.nui, @post]
  end

  private
  def set_post
    @post = Post.find(params[:post_id])
  end
end
