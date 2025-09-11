# app/controllers/nuis_controller.rb
class NuisController < ApplicationController
  before_action :authenticate_user!
  before_action :set_nui, only: [:show, :edit, :update, :destroy, :followers]
  before_action :authorize_owner!, only: [:edit, :update, :destroy]

  def new
    @nui = Nui.new(user: current_user)   # buildだと未保存が一覧に混ざるためnew推奨
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
    @posts = @nui.posts.published
                   .includes(:nui, :likes, :comments, image_attachment: :blob)
                   .order(created_at: :desc)
                   .page(params[:page]).per(10)
  end
  
  

  def edit; end

  def update
    if @nui.update(nui_params)
      redirect_to @nui, notice: "プロフィールを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if current_user.nuis.count <= 1
      redirect_to @nui, alert: "ぬいがいなくなってしまうので、削除できません"
      return
    end
    @nui.destroy
    redirect_to user_path(current_user), notice: "ぬいを削除しました"
  end

  def followers
    @follows = @nui.follows.includes(:user).order(created_at: :desc)
  end

  private
  def set_nui
    @nui = Nui.find(params[:id])
  end

  def authorize_owner!
    redirect_to @nui, alert: "編集権限がありません" unless @nui.user_id == current_user.id
  end

  # ★ここがなかった（or名前違い）
  def nui_params
    params.require(:nui).permit(:name, :profile, :avatar)
  end
end
