class Playlist < ApplicationRecord
  belongs_to :user
  belongs_to :chat

  # Bookmarks for this playlist (likes)
  has_many :bookmarks, as: :bookmarkable, dependent: :destroy

  # Users who bookmarked/liked this playlist
  has_many :bookmarked_by_users, through: :bookmarks, source: :user

  has_many :playlist_tracks, dependent: :destroy
  has_many :tracks, through: :playlist_tracks
  # has_many :chats, dependent: :destroy
end
