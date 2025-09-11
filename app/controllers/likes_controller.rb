# app/controllers/likes_controller.rb
class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_nui_and_post

  def create
    # user単位のいいね（重複作成を避ける）
    current_user.likes.find_or_create_by!(post: @post)
    redirect_back fallback_location: [@nui, @post], notice: nil
  end

  def destroy
    current_user.likes.where(post: @post).destroy_all
    redirect_back fallback_location: [@nui, @post], notice: nil
  end

  private
  def set_nui_and_post
    @nui  = Nui.find(params[:nui_id])
    @post = @nui.posts.find(params[:post_id])
  end
end
