# app/controllers/nuis_controller.rb
class NuisController < ApplicationController
  before_action :authenticate_user!, except: [:show, :followers]
  before_action :set_nui, only: [:show, :edit, :update, :destroy, :followers]
  before_action :authorize_owner!, only: [:edit, :update, :destroy]

  def show
    @posts = @nui.posts.includes(:nui, :likes, :comments).order(created_at: :desc)
  end

  def followers
    # フォロワー一覧（ユーザー）
    @follows = @nui.follows.includes(:user).order(created_at: :desc)
  end

  def destroy
    @nui.destroy
    redirect_to root_path, notice: "ぬいを削除しました"
  end
  
  private
  def set_nui
    @nui = Nui.find(params[:id])  # ← /nuis/:id/followers の :id を使う
  end

  def authorize_owner!
    redirect_to @nui, alert: "編集権限がありません" unless @nui.user_id == current_user.id
  end
end
