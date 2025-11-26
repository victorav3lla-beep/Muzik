class ChatsController < ApplicationController

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
