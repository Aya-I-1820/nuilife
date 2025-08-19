# app/controllers/posts_controller.rb
class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_nui
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def new
    @post = @nui.posts.build
  end

  def create
    @post = @nui.posts.build(post_params)
    if @post.save
      redirect_to [@nui, @post], notice: "投稿しました！"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  # （編集や削除を入れる場合）
  def edit; end
  def update
    if @post.update(post_params)
      redirect_to [@nui, @post], notice: "投稿を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end
  def destroy
    @post.destroy
    redirect_to root_path, notice: "投稿を削除しました"
  end

  private
  def set_nui
    @nui = current_user.nuis.find(params[:nui_id])  # 自分のぬいのみ
  end

  def set_post
    @post = @nui.posts.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:content, :image)
  end
end
