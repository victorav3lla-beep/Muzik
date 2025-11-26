class PlaylistsController < ApplicationController
  def new
    @playlist = Playlist.new
    @chat = Chat.new
    @message = Message.new
  end

  def create
    @playlist = current_user.Playlist.new(playlist_params)
    # @playlist.made = RubyLLM.chat.ask("Generate a playlist from this text: #{@playlist.queary}").content
    if @playlist.save
    redirect_to playlist_path(@playlist), notice: "Playlist was successfully created! WOOOOO!!🎉🎉"
    else
    render :new, status: :unprocessable_entity
    end
  end

  def index
    @playlists = current_user.playlists
  end

  def show
    @playlist = Playlist.find(params[:id])
  end

  private

  def playlist_params
    params.require(playlist:).permit(:title, :content)
  end

end
