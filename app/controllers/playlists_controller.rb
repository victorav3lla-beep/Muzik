class PlaylistsController < ApplicationController
  def new
    @playlist = Playlist.new
    @chat = Chat.create(user: current_user)
    @message = Message.new
  end

  def create
    @playlist = current_user.playlists.new(playlist_params)
    # @playlist.made = RubyLLM.chat.ask("Generate a playlist from this text: #{@playlist.query}").content
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
    @track = Track.new # Initialize empty track for the form
  end

  private

  def playlist_params
    params.require(:playlist).permit(:title, :content)
  end

end
