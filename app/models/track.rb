# app/models/track.rb
class Track < ApplicationRecord
  has_many :playlist_tracks, dependent: :destroy
  has_many :playlists, through: :playlist_tracks

  validates :title, :artist, :url, :duration, presence: true
end