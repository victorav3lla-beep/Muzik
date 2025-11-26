class Message < ApplicationRecord
  belongs_to :chat

  def role_string
    user ? "user":"assistant"
  end
end
