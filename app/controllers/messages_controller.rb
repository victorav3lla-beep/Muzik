class MessagesController < ApplicationController
SYSTEM_PROMPT = "You are a Playlists Creator\n\nI am a Spotify user who wants to create playlists using AI.\n\nHelp me create playlists, doing questions to understand what I want from it.\n\nAnswer with a playlist related to the prompt."

  def create
    @chat = current_user.chats.find(params[:chat_id])
    # @playlist = @chat.playlist

    @message = Message.new(message_params)
    @message.chat = @chat
    @message.user = true

    if @message.save
      @ruby_llm_chat = RubyLLM.chat
      build_conversation_history

      response = @ruby_llm_chat.with_instructions(instructions).ask(@message.content)

      Message.create(user: false, content: response.content, chat: @chat)

      @chat.generate_title_from_first_message

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to chat_path(@chat)}
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace('new_message',
                                      partial: 'messages/form',
                                      locals: { chat: @chat, message: @message }) }
        format.html { render "chats/show", status: :unprocessable_entity }
      end
    end
  end


  private

  def build_conversation_history
    @chat.messages.each do |message|
      role = message.user? ? :user : :assistant

      @ruby_llm_chat.add_message(
        role: role,
        content: message.content
      )
    end
  end

  def message_params
    params.require(:message).permit(:content)
  end

  def instructions
    [SYSTEM_PROMPT].compact.join("\n\n")
  end
end
