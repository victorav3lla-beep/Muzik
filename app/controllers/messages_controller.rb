class MessagesController < ApplicationController
SYSTEM_PROMPT = "You are a specialized Playlists Creator and curator\n\nI am a Spotify user who wants to create playlists using AI with a basic promp.\n\nHelp me create a playlist with tracks related to the topic I am giving you in the prompt.\n\nAnswer with a playlist with following format:
{
  track_id: {
    Title: track_title
    Artist: track_artist
    url: track_url
    Duration: track_duration
    }
  track_2: {
    Title: track_title
    Artist: track_artist
    url: track_url
    Duration: track_duration
    }
  track_3: {
    Title: track_title
    Artist: track_artist
    url: track_url
    Duration: track_duration
    }
  }
}."

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

      @response_playlist = response.content
      @playlist = Playlist.create(title: "title",user: current_user)

      Track.create(title: @response_playlist.title, artist: @response_playlist.artist, url: @response_playlist.url, duration: @response_playlist.duration)


      #create the playlist_tracks with track id and playlist id
      #migration reference playlist to tracks
      #create a playlist instance
      #create tracks based on the response

      @chat.generate_title_from_first_message

      # respond_to do |format|
      #   format.turbo_stream
      #   format.html { redirect_to chat_path(@chat)}
      # end
      redirect_to playlist_path(@playlist)
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
