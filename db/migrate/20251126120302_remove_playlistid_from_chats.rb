class RemovePlaylistidFromChats < ActiveRecord::Migration[7.1]
  def change
    remove_column :chats, :playlist_id
  end
end
