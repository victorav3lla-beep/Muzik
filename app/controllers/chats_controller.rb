class ChatsController < ApplicationController

SYSTEM_PROMPT = "You are a Playlists Creator\n\nI am a Spotify user who wants to create playlists using AI.\n\nHelp me create playlists, doing questions to understand what I want from it.\n\nAnswer with a playlist related to the prompt."
  def show
    @chat    = current_user.chats.find(params[:id])
    @message = Message.new
  end

  def create
    @playlist = Playlist.find(params[:playlist_id])

    @chat = Chat.new(title: "New Muzik Chat")
    @chat.playlist = @playlist
    @chat.user = current_user

    if @chat.save
      ruby_llm_chat = RubyLLM.chat
      response = ruby_llm_chat.with_instructions(SYSTEM_PROMPT).ask(@message.content)
      Message.create

      redirect_to chat_path(@chat)
    else
      render "playlists/show", status: :unprocessable_entity
    end
  end

  private

  def chat_params
    params.require(:chat).permit(:title)
  end
end
