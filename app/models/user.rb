class User < ApplicationRecord
  has_many :playlists, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :chats, dependent: :destroy
end
