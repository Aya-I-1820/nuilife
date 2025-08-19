# app/controllers/nuis_controller.rb
class NuisController < ApplicationController
  before_action :authenticate_user!
  before_action :set_nui, only: [:show, :edit, :update, :destroy]

  def new
    @nui = current_user.nuis.build
  end

  def create
    @nui = current_user.nuis.build(nui_params)
    if @nui.save
      redirect_to @nui, notice: "ぬいを作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    # このぬいの投稿を、新しい順で。likes/commentsも事前読込してN+1回避
    @posts = @nui.posts
    .includes(:nui, :likes, :comments)  # ← いいね/コメント数を速く
    .order(created_at: :desc)
  end
  def edit; end

  def update
    if @nui.update(nui_params)
      redirect_to @nui, notice: "ぬいを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @nui.destroy
    redirect_to root_path, notice: "ぬいを削除しました"
  end

  private

  def set_nui
    @nui = current_user.nuis.find(params[:id])
  end

  def nui_params
    params.require(:nui).permit(:name, :profile, :avatar)
  end
end
