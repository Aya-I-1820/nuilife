class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  # 読み取り用（他人のぬいも可）
  before_action :set_nui_for_read, only: [:show]

  # 書き込み用（自分のぬいのみ）
  before_action :set_nui_for_write, only: [:new, :create, :edit, :update, :destroy]

  before_action :set_post_for_read,  only: [:show]
  before_action :set_post_for_write, only: [:edit, :update, :destroy]

  def index
    @posts = Post.includes(:nui, :likes, :comments).order(created_at: :desc)
  end

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

  def show
    @comments = @post.comments.includes(:nui).order(created_at: :asc)
  end

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

  # ---- READ（他人OK）----
  def set_nui_for_read
    @nui = Nui.find(params[:nui_id])
  end

  def set_post_for_read
    @post = @nui.posts.find(params[:id])
  end

  # ---- WRITE（自分のぬい限定）----
  def set_nui_for_write
    @nui = current_user.nuis.find(params[:nui_id])
  end

  def set_post_for_write
    @post = @nui.posts.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:post, :image)
  end
end
