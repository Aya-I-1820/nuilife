class CommentsController < ApplicationController
  before_action :authenticate_user!   # ログイン必須
  before_action :set_post
  def create
    @comment = @post.comments.build(comment_params)
    @comment.nui = current_nui   # 「どのぬいでコメントしたか」

    if @comment.save
      redirect_to @post, notice: "コメントを投稿しました！"
    else
      redirect_to @post, alert: "コメントできませんでした。"
    end
  end

  def destroy
    @comment = @post.comments.find(params[:id])
    if @comment.nui == current_nui
      @comment.destroy
      redirect_to @post, notice: "コメントを削除しました。"
    else
      redirect_to @post, alert: "削除権限がありません。"
    end
  end

  private
  
  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

end
