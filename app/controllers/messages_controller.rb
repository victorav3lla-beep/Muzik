class MessagesController < ApplicationController
  def create
    @chat = current_user.chats.find(params[:chat_id])
    @playlist = @chat.playlist

    @message = Message.new(message_params)
    @message.chat = @chat
    @message.user = true

    if @message.save
      muzik_chat = RubyLLM.chat
      response = muzik_chat.ask(@message.content)
      Message.create(user: false, content: response.content, chat: @chat)

      redirect_to chat_messages_path(@chat)
    else
      render "chats/show", status: :unprocessable_entity
    end
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
