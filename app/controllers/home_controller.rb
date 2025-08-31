# app/controllers/home_controller.rb
class HomeController < ApplicationController
  def index
    return unless user_signed_in?
  
    @tab = %w[all following].include?(params[:tab]) ? params[:tab] : "all"
  
    base = Post.published.includes(:nui, :likes, :comments, image_attachment: :blob).order(created_at: :desc)
    @posts_all       = base.limit(50)
    followed_ids     = current_user.followed_nuis.select(:id)
    @posts_following = base.where(nui_id: followed_ids).limit(50)
  end
  
end
