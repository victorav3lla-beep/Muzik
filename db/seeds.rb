puts "Cleaning database..."
Playlist.destroy_all
Chat.destroy_all


playlist_rock = Playlist.create(title: "rock", content: "123", user_id: 1)

chat_1 = Chat.create(title: "new vibes")

puts "finished creating..."
