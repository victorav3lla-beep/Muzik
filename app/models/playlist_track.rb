class PlaylistTrack < ApplicationRecord
  belongs_to :track
  belongs_to :playlist
  has_many :songs, dependent: :destroy
end
