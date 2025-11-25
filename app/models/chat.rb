class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :playlist
  has_many :messages
end
