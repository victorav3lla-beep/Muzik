# app/models/playlist_track.rb
class PlaylistTrack < ApplicationRecord
  belongs_to :playlist
  belongs_to :track

  # Prevent the same track from being added twice to the same playlist
  validates :track_id, uniqueness: { scope: :playlist_id, message: "is already in this playlist" }
end