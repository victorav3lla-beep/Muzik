class Playlist < ApplicationRecord
  belongs_to :user
  has_many :bookmarks, dependent: :destroy
  # has_many :chats, dependent: :destroy
end
