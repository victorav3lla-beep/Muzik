class MessagesController < ApplicationController
SYSTEM_PROMPT = <<~PROMPT
IMPORTANT: Only generate YouTube videos that are embeddable and playable in an iframe, double check that each link is available outside YouTube and will be available in this app. You are a specialized Playlists Creator and curator\n\nI am a Youtube Music user who wants to create playlists using AI with a basic promp, and will use your response to create a playlist in my app and embed the url's.\n\nHelp me create a playlist with tracks related to the topic I am giving you in the prompt.\n\nOnly return YouTube videos that are embeddable and can be played in an iframe Answer with a playlist of 10 to 15 tracks with following format:
{
  "track_id": {
    "Title": "track_title",
    "Artist": "track_artist",
    "Url": "track_url",
    "Duration": "track_duration",
    },
  "track_id": {
    "Title": "track_title",
    "Artist": "track_artist",
    "Url": "track_url",
    "Duration": "track_duration",
    },
  "track_id": {
    "Title": "track_title",
    "Artist": "track_artist",
    "Url": "track_url",
    "Duration": "track_duration",
    },
}
PROMPT

ADD_TRACK_PROMPT = <<~PROMPT
IMPORTANT: If the conversation already has a playlist, created from previous messages, the user is asking you to ADD NEW TRACKS to the existing playlist. You must return ONLY new tracks, not the previous ones, but using the new prompt given by the user.
- Do NOT repeat tracks that are already in the first response.
- Always use the same JSON structure shown above.

Return ONLY new tracks in this format:

{
  "new_track_id": {
    "Title": "track_title",
    "Artist": "track_artist",
    "Url": "track_url",
    "Duration": "track_duration"
  },
  ...
}
PROMPT


  def create
    @chat = current_user.chats.find(params[:chat_id])
    # @playlist = @chat.playlist

    @message = Message.new(message_params)
    @message.chat = @chat
    @message.user = true

    if @message.save
      if @chat.messages.count == 1
        @ruby_llm_chat = RubyLLM.chat

        build_conversation_history

        response = @ruby_llm_chat.with_instructions(instructions).ask(@message.content)

        Message.create(user: false, content: response.content, chat: @chat)
        @chat.generate_title_from_first_message

        @response_tracks = JSON.parse(response.content)

        @playlist = Playlist.create(title: @chat.title ,user: current_user, chat: @chat)

        @response_tracks.each do |track_id, track_details|

          search_query = "#{track_details['Title']} #{track_details['Artist']}"
          youtube_url = YoutubeService.search(search_query)
          track = Track.create(
            title: track_details["Title"],
            artist: track_details["Artist"],
            url: youtube_url || track_details["Url"],
            duration: track_details["Duration"]
            )
            PlaylistTrack.create(playlist: @playlist, track: track)
        end

          @chat.generate_title_from_first_message


        #create the playlist_tracks with track id and playlist id
        #migration reference playlist to tracks
        #create a playlist instance
        #create tracks based on the response


        redirect_to playlist_path(@playlist)
        #first prompt
      else
        #second prompt, feeds ai with existing list of songs and initial user message
        @ruby_llm_chat = RubyLLM.chat
        build_conversation_history

        @playlist = @chat.playlist

        response = @ruby_llm_chat.with_instructions(instructions).ask(@message.content)
        Message.create(user: false, content: response.content, chat: @chat)

        @response_tracks = JSON.parse(response.content)

        @response_tracks.each do |track_id, track_details|

          search_query = "#{track_details['Title']} #{track_details['Artist']}"
          youtube_url = YoutubeService.search(search_query)
          track = Track.create(
            title: track_details["Title"],
            artist: track_details["Artist"],
            url: youtube_url || track_details["Url"],
            duration: track_details["Duration"]
            )
            PlaylistTrack.create(playlist: @playlist, track: track)


            respond_to do |format|
          format.turbo_stream { render turbo_stream: turbo_stream.append('track',
                                      partial: 'playlists/track_template',
                                      locals: { chat: @chat, message: @message }) }
          format.html { redirect_to playlist_path(@playlist) }
        end
      end
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
    @chat.messages.where(user: true).each do |message|

      @ruby_llm_chat.add_message(
        role: :user,
        content: message.content
      )
    end
  end

  def message_params
    params.require(:message).permit(:content)
  end

  def instructions
    if @chat.messages.count == 1
      [SYSTEM_PROMPT].compact.join("\n\n")
    else
      [ADD_TRACK_PROMPT].compact.join("\n\n")
    end
  end
end
