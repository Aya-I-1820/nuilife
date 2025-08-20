# app/controllers/comments_controller.rb
class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_nui_for_read
  before_action :set_post

  def create
    # ユーザーが選んだ自分のぬいでコメント
    commenter = current_user.nuis.find(comment_params[:nui_id])

    @comment = @post.comments.build(
      content: comment_params[:content],
      nui: commenter
    )

    if @comment.save
      redirect_to [@nui, @post], notice: "コメントを投稿しました！"
    else
      # Post#show にコメント欄を描くため、エラー時も show を再描画
      @comments = @post.comments.includes(:nui).order(created_at: :asc)
      flash.now[:alert] = "コメントできませんでした。"
      render "posts/show", status: :unprocessable_entity
    end
  end

  def destroy
    comment = @post.comments.find(params[:id])
    if comment.nui.user_id == current_user.id
      comment.destroy
      redirect_to [@nui, @post], notice: "コメントを削除しました。"
    else
      redirect_to [@nui, @post], alert: "削除権限がありません。"
    end
  end

  private
  def set_nui_for_read
    @nui = Nui.find(params[:nui_id])             # 読み取りは他人のぬいもOK
  end
  def set_post
    @post = @nui.posts.find(params[:post_id])
  end
  def comment_params
    params.require(:comment).permit(:content, :nui_id)
  end
end
