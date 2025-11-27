# db/migrate/20251127120000_create_tracks.rb
class CreateTracks < ActiveRecord::Migration[7.0]
  def change
    create_table :tracks do |t|
      t.string :title
      t.string :artist
      t.string :url
      t.integer :duration

      t.timestamps
    end
  end
end
