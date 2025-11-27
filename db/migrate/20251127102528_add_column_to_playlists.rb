class AddColumnToPlaylists < ActiveRecord::Migration[7.1]
  def change
    add_reference :playlists, :chat, null: false, foreign_key: true
  end
end
