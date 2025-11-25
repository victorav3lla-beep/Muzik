class User < ApplicationRecord
  has_many :playlists,
  has_many :bookmarks,
  has_many :chats
end
