class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :playlists, dependent: :destroy
  has_many :chats, dependent: :destroy

  # Bookmarks created by this user
  has_many :bookmarks, dependent: :destroy

  # Bookmarks received (when other users follow this user)
  has_many :received_bookmarks, class_name: 'Bookmark', as: :bookmarkable, dependent: :destroy

  # Convenient associations
  has_many :bookmarked_playlists, through: :bookmarks, source: :bookmarkable, source_type: 'Playlist'
  has_many :bookmarked_users, through: :bookmarks, source: :bookmarkable, source_type: 'User'
  has_many :followers, through: :received_bookmarks, source: :user
end
