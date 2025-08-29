# app/controllers/messages_controller.rb
class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation

  def create
    redirect_to root_path, alert: "アクセスできません" and return unless @conversation.includes?(current_user)
    @message = @conversation.messages.build(message_params.merge(user: current_user))
    if @message.save
      redirect_to @conversation
    else
      @messages = @conversation.messages.includes(:user).order(:created_at)
      render "conversations/show", status: :unprocessable_entity
    end
  end

  private
  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end

  def message_params
    params.require(:message).permit(:body)
  end
end
