class MessagesController < ApplicationController
  def create
    @chat = current_user.chats.find(params[:chat_id])
    @playlist = @chat.playlist

    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"

    if @message.save
      muzik_chat = RubyLLM.chat
      response = muzik_chat.with_instructions(instructions).ask(@message.content)
      Message.create(role: "assistant", content: response.content, chat: @chat)

      redirect_to chat_messages_path(@chat)
    else
      render "chats/show", status: :unprocessable_entity
    end
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
