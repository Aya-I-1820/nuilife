# app/controllers/home_controller.rb
class HomeController < ApplicationController
  def index
    return unless user_signed_in?

    @tab = %w[all following].include?(params[:tab]) ? params[:tab] : "all"

    base = Post.includes(:nui, :likes, :comments).order(created_at: :desc)

    # みんなの投稿
    @posts_all = base.limit(50)

    # フォロー中のぬいの投稿
    followed_ids = current_user.followed_nuis.select(:id) # サブクエリで効率よく
    @posts_following = base.where(nui_id: followed_ids).limit(50)
  end
end
