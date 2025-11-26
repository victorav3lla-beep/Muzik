class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :playlist
  has_many :messages, dependent: :destroy

  DEFAULT_TITLE = "Untitled"
  TITLE_PROMPT = <<~PROMPT
  Generate a short, descriptive, 3-to-6-word title that summarizes the user question for a chat conversation.
  PROMPT

end
