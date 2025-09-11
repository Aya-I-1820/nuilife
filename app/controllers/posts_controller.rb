# app/controllers/posts_controller.rb
class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_nui, only: [:new, :create, :edit, :update, :destroy, :show, :drafts]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authorize_owner!, only: [:new, :create, :edit, :update, :destroy, :drafts]

  def new
    @post = @nui.posts.build
  end

  def index
    @posts = Post.published
                 .includes(:nui, :likes, :comments, image_attachment: :blob)
                 .order(created_at: :desc)
                 .page(params[:page]).per(10)
  end
  
  

  def create
    @post = @nui.posts.build(post_params)

    # どのボタンが押されたかで status を分岐
    @post.status = (params[:commit] == "下書き保存") ? :draft : :published

    if @post.save
      if @post.draft?
        redirect_to drafts_nui_posts_path(@nui), notice: "下書きを保存しました"
      else
        redirect_to [@nui, @post], notice: "投稿しました！"
      end
    else
      flash.now[:alert] = "保存できませんでした"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    # 編集でも押したボタンで分岐
    next_status = (params[:commit] == "下書き保存") ? :draft : (params[:commit] == "公開する" ? :published : @post.status)
    @post.assign_attributes(post_params.merge(status: next_status))

    if @post.save
      if @post.draft?
        redirect_to drafts_nui_posts_path(@nui), notice: "下書きを更新しました"
      else
        redirect_to [@nui, @post], notice: "投稿を更新しました"
      end
    else
      flash.now[:alert] = "更新できませんでした"
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    # 下書きは本人以外見せない
    if @post.draft? && @post.nui.user_id != current_user.id
      redirect_to @nui, alert: "この投稿は表示できません" and return
    end

    # ★ コメント一覧とフォーム用インスタンスを用意
    @comments = @post.comments
                     .includes(nui: { avatar_attachment: :blob })
                     .order(created_at: :asc)
    @comment  = @post.comments.build
  end
  
  def destroy
    @post.destroy
    redirect_to @nui, notice: "投稿を削除しました"
  end

  # 下書き一覧
  def drafts
  @posts = @nui.posts
               .draft            
               .includes(:nui, :likes, :comments, image_attachment: :blob)
               .order(updated_at: :desc)
               .page(params[:page]).per(10)
  end


  def search
    @q = params[:q].to_s.strip
    @posts = Post.published
                 .joins(:nui)
                 .includes(:nui, :likes, :comments, image_attachment: :blob)
                 .where("posts.post LIKE :q OR nuis.name LIKE :q", q: "%#{@q}%")
                 .order(created_at: :desc)
                 .page(params[:page]).per(10)
  end

  private
  def set_nui
    @nui = Nui.find(params[:nui_id])
  end

  def set_post
    @post = @nui.posts.find(params[:id])
  end

  def authorize_owner!
    redirect_to root_path, alert: "権限がありません" unless @nui.user_id == current_user.id
  end

  def post_params
    params.require(:post).permit(:post, :image)
  end
end
