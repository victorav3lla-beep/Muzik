# app/controllers/tracks_controller.rb
class TracksController < ApplicationController
  before_action :set_playlist

  def create
    @track = Track.new(track_params)


    ActiveRecord::Base.transaction do
      if @track.save
        @playlist_track = PlaylistTrack.new(playlist: @playlist, track: @track)

        if @playlist_track.save
          redirect_to playlist_path(@playlist), notice: 'Track was successfully added to the playlist.'
          return
        else
          flash.now[:alert] = 'This track is already in this playlist.'
        end
      end
    end

    # If we reach here, something failed - render the form again with errors
    render 'playlists/show', status: :unprocessable_entity
  rescue ActiveRecord::RecordNotUnique
    # Database-level uniqueness constraint violated
    flash.now[:alert] = 'This track is already in this playlist.'
    render 'playlists/show', status: :unprocessable_entity
  end

  private

  def set_playlist
    @playlist = Playlist.find(params[:playlist_id])
  end

  def track_params
    params.require(:track).permit(:title, :artist, :url, :duration)
  end
end
