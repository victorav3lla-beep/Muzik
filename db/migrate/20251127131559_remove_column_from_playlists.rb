class RemoveColumnFromPlaylists < ActiveRecord::Migration[7.1]
  def change
    remove_reference :playlists, :track, null: false, foreign_key: true
  end
end
