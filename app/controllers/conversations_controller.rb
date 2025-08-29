# app/controllers/conversations_controller.rb
class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation, only: [:show]

  def index
    @conversations = current_user.conversations
                                 .includes(:user1, :user2, :messages)
                                 .order(updated_at: :desc)
  end

  # 新規作成 or 既存再利用（相手IDで）
  def create
    other = User.find(params[:user_id])
    a, b = [current_user.id, other.id].minmax
    @conversation = Conversation.find_or_create_by!(user1_id: a, user2_id: b)
    redirect_to @conversation
  end

  def show
    redirect_to root_path, alert: "アクセスできません" and return unless @conversation.includes?(current_user)
    @messages = @conversation.messages.includes(:user).order(:created_at)
    @message  = Message.new
  end

  private
  def set_conversation
    @conversation = Conversation.find(params[:id])
  end
end
