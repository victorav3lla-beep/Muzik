class AddColumnToTracks < ActiveRecord::Migration[7.1]
  def change
    add_column :tracks, :url, :string
    add_column :tracks, :duration, :string
  end
end
