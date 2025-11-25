class Message < ApplicationRecord
  belongs_to :chat

  def role_string
    user ? "user":"bot"
  end
end
