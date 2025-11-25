class Playlist < ApplicationRecord
  belongs_to :user
  has_many :bookmarks
  has_many :chats
end
