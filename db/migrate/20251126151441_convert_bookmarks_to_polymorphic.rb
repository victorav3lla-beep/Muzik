class ConvertBookmarksToPolymorphic < ActiveRecord::Migration[7.1]
  def up
    # Remove the existing playlist foreign key if it exists
    if foreign_key_exists?(:bookmarks, :playlists)
      remove_foreign_key :bookmarks, :playlists
    end

    # Remove the playlist_id column if it exists
    if column_exists?(:bookmarks, :playlist_id)
      remove_column :bookmarks, :playlist_id
    end

    # Add polymorphic columns only if they don't exist
    unless column_exists?(:bookmarks, :bookmarkable_type)
      add_reference :bookmarks, :bookmarkable, polymorphic: true, null: false, index: true
    end

    # Add unique index to prevent duplicate bookmarks
    unless index_exists?(:bookmarks, [:user_id, :bookmarkable_type, :bookmarkable_id], name: 'index_bookmarks_on_user_and_bookmarkable')
      add_index :bookmarks, [:user_id, :bookmarkable_type, :bookmarkable_id],
                unique: true,
                name: 'index_bookmarks_on_user_and_bookmarkable'
    end
  end

  def down
    # Remove the unique index if it exists
    if index_exists?(:bookmarks, [:user_id, :bookmarkable_type, :bookmarkable_id], name: 'index_bookmarks_on_user_and_bookmarkable')
      remove_index :bookmarks, name: 'index_bookmarks_on_user_and_bookmarkable'
    end

    # Remove polymorphic columns if they exist
    if column_exists?(:bookmarks, :bookmarkable_type)
      remove_reference :bookmarks, :bookmarkable, polymorphic: true, index: true
    end

    # Re-add playlist_id column if it doesn't exist
    unless column_exists?(:bookmarks, :playlist_id)
      add_reference :bookmarks, :playlist, null: false, foreign_key: true
    end
  end
end
