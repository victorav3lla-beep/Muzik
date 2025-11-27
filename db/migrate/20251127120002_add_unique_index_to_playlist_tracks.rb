class AddUniqueIndexToPlaylistTracks < ActiveRecord::Migration[7.1]
  def change
    # Add unique compound index to prevent duplicate tracks in the same playlist
    # add_index :playlist_tracks, [:playlist_id, :track_id], unique: true
  end
end
