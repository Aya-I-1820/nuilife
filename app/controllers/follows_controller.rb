# app/controllers/follows_controller.rb
class FollowsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_nui

  def create
    current_user.follows.find_or_create_by!(nui: @nui)
    redirect_to @nui, notice: "フォローしました"
  end

  def destroy
    current_user.follows.find_by(nui: @nui)&.destroy
    redirect_to @nui, notice: "フォローを解除しました"
  end

  private
  def set_nui
    @nui = Nui.find(params[:nui_id])   # 読み取りは誰のぬいでもOK
  end
end
